import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _searchResults = [];
  bool _isLoading = false;

  void _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    // Perform a case-insensitive search on the 'userName' field
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isGreaterThanOrEqualTo: query)
        .where('userName', isLessThan: query + 'z')
        .get();

    setState(() {
      _searchResults = querySnapshot.docs;
      _isLoading = false;
    });
  }

  void _addUserToConversations(
      String userId, String userName, String avatarUrl) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Check if a conversation already exists
    QuerySnapshot existingConversations = await FirebaseFirestore.instance
        .collection('conversations')
        .where('participants', arrayContains: currentUserId)
        .get();

    DocumentReference? conversationRef;

    for (var doc in existingConversations.docs) {
      List<dynamic> participants = doc['participants'];
      if (participants.contains(userId)) {
        conversationRef = doc.reference;
        break;
      }
    }

    // If no conversation exists, create a new one
    if (conversationRef == null) {
      conversationRef =
          await FirebaseFirestore.instance.collection('conversations').add({
        'participants': [currentUserId, userId],
        'lastMessage': null,
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
      });
    }

    // Navigate to the chat page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          otherUserId: userId,
          otherUserName: userName,
          otherUserAvatarUrl: avatarUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for users',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _performSearch(_searchController.text),
                ),
              ),
              onSubmitted: _performSearch,
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      var userData =
                          _searchResults[index].data() as Map<String, dynamic>;
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
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => _addUserToConversations(
                              _searchResults[index].id, userName, avatarUrl),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
