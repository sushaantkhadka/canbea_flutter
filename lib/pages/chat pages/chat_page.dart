import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String otherUserId;
  final String otherUserName;
  final String otherUserAvatarUrl;
  final bool initialIsPendingRequest;
  final String? initialConversationId;

  ChatPage({
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserAvatarUrl,
    this.initialIsPendingRequest = false,
    this.initialConversationId,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  late bool _isPendingRequest;
  String? _conversationId;

  @override
  void initState() {
    super.initState();
    _isPendingRequest = widget.initialIsPendingRequest;
    _conversationId = widget.initialConversationId;
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _conversationId == null)
      return;

    await FirebaseFirestore.instance
        .collection('conversations')
        .doc(_conversationId)
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'text': _messageController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await FirebaseFirestore.instance
        .collection('conversations')
        .doc(_conversationId)
        .update({
      'lastMessage': _messageController.text,
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  void _acceptRequest() async {
    // Create a new conversation
    DocumentReference conversationRef =
        await FirebaseFirestore.instance.collection('conversations').add({
      'participants': [currentUserId, widget.otherUserId],
      'lastMessage': null,
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
    });

    // Delete the request
    await FirebaseFirestore.instance
        .collection('requests')
        .where('senderId', isEqualTo: widget.otherUserId)
        .where('recipientId', isEqualTo: currentUserId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });

    // Update the state
    setState(() {
      _isPendingRequest = false;
      _conversationId = conversationRef.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.otherUserAvatarUrl.isNotEmpty
                  ? NetworkImage(widget.otherUserAvatarUrl)
                  : null,
              child: widget.otherUserAvatarUrl.isEmpty
                  ? Text(widget.otherUserName[0])
                  : null,
            ),
            SizedBox(width: 8),
            Text(widget.otherUserName),
          ],
        ),
        actions: _isPendingRequest
            ? [
                TextButton(
                  child: Text('Accept', style: TextStyle(color: Colors.white)),
                  onPressed: _acceptRequest,
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: _conversationId == null
                ? Center(child: Text('Accept the request to start chatting'))
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('conversations')
                        .doc(_conversationId)
                        .collection('messages')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return ListView(
                        reverse: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          bool isMe = data['senderId'] == currentUserId;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Align(
                              alignment: isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? Colors.blue[100]
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                child: Text(data['text']),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
          ),
          if (!_isPendingRequest && _conversationId != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
