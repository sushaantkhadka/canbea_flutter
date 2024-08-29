import 'package:canbea_flutter/pages/chat%20pages/chat_page.dart';
import 'package:canbea_flutter/pages/chat%20pages/request_page.dart';
import 'package:canbea_flutter/pages/chat%20pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConversationsPage extends StatelessWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversations'),
        actions: [
          IconButton(
            icon: Icon(Icons.mail),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RequestsPage()),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('conversations')
            .where('participants', arrayContains: currentUserId)
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
              String otherUserId = (data['participants'] as List<dynamic>)
                  .firstWhere((id) => id != currentUserId);

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
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
                      subtitle: Text(data['lastMessage'] ?? 'No messages yet'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              otherUserId: otherUserId,
                              otherUserName: userName,
                              otherUserAvatarUrl: avatarUrl,
                              initialConversationId: document.id,
                              initialIsPendingRequest: false,
                            ),
                          ),
                        );
                      },
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => SearchPage())),
      ),
    );
  }
}
