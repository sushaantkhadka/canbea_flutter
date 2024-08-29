import 'package:canbea_flutter/helper/helper_function.dart';
import 'package:canbea_flutter/service/database_service.dart';
import 'package:canbea_flutter/widgets/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClubchatPage extends StatefulWidget {
  const ClubchatPage({super.key});

  @override
  State<ClubchatPage> createState() => _ClubchatPageState();
}

class _ClubchatPageState extends State<ClubchatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();

  String userName = "";
  String club = "";

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  Future<void> _initializeChat() async {
    try {
      // Fetch userName from shared preferences
      userName = await HelperFunction.getUserNameFromSF() ?? "";

      // Fetch user data and club information
      final userData =
          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData();
      if (userData.docs.isNotEmpty) {
        club = userData.docs[0]['club'] ?? "";
        if (club.isNotEmpty) {
          setState(() {
            chats = DatabaseService().getChats(getId(club));
          });
        }
      }
    } catch (e) {
      print('Error initializing chat: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.yellow[700],
        centerTitle: true,
        title: const Text("Club Chat",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: club.isEmpty
            ? const Text(
                "You are not part of any club.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )
            : Stack(
                children: <Widget>[
                  chatMessages(),
                  Container(
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.amber[100],
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: messageController,
                              style: const TextStyle(color: Colors.grey),
                              decoration: const InputDecoration(
                                hintText: "Send Messages....",
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              sendMessage();
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Center(
                                child: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget chatMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: chats,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "No messages yet.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data!.docs[index];
            return MessageTile(
              message: messageData['message'],
              sender: messageData['sender'],
              sentByMe: userName == messageData['sender'],
            );
          },
        );
      },
    );
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty && club.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(getId(club), chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
