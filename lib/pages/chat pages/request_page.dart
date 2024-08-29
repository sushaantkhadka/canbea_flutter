import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_page.dart';

class RequestsPage extends StatelessWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  void _handleRequest(BuildContext context, String requestId, String senderId,
      String senderName, String senderAvatarUrl, bool accept) async {
    if (accept) {
      // Create a new conversation
      DocumentReference conversationRef =
          await FirebaseFirestore.instance.collection('conversations').add({
        'participants': [currentUserId, senderId],
        'lastMessage': null,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
      });

      // Navigate to the chat page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            otherUserId: senderId,
            otherUserName: senderName,
            otherUserAvatarUrl: senderAvatarUrl,
            initialIsPendingRequest: true,
          ),
        ),
      );
    }

    // Delete the request
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(requestId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Requests'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('requests')
            .where('recipientId', isEqualTo: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(data['senderId'])
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> userData =
                        userSnapshot.data!.data() as Map<String, dynamic>;
                    String userName = userData['userName'] ?? 'Unknown User';
                    String avatarUrl = userData['avatarUrl'] ?? '';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: avatarUrl.isNotEmpty
                            ? NetworkImage(avatarUrl)
                            : null,
                        child: avatarUrl.isEmpty ? Text(userName[0]) : null,
                      ),
                      title: Text(userName),
                      subtitle: Text('Wants to chat with you'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check, color: Colors.green),
                            onPressed: () => _handleRequest(
                                context,
                                document.id,
                                data['senderId'],
                                userName,
                                avatarUrl,
                                true),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () => _handleRequest(
                                context,
                                document.id,
                                data['senderId'],
                                userName,
                                avatarUrl,
                                false),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListTile(
                    leading: CircularProgressIndicator(),
                    title: Text('Loading...'),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
