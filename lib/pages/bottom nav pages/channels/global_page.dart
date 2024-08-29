import 'package:canbea_flutter/helper/helper_function.dart';
import 'package:canbea_flutter/service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GlobalPage extends StatefulWidget {
  const GlobalPage({super.key});

  @override
  State<GlobalPage> createState() => _GlobalPageState();
}

class _GlobalPageState extends State<GlobalPage> {
  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  Future<void> gettingUserData() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .gettingUserData()
        .then((val) {
      setState(() {
        userName = val.docs[0]['userName'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg1.png"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.yellow[700],
          centerTitle: true,
          title: const Text(
            "Global Chat",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 100),
              child: chatMessages(),
            ),
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
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: sendMessage,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                        ),
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
      stream: _firestore
          .collection('global')
          .orderBy('time', descending: true)
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final messages = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final messageData = messages[index].data() as Map<String, dynamic>;
            final sender = messageData['sender'] ?? 'Unknown';
            final message = messageData['message'] ?? '';

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sender,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.purple),
                  ),
                  const SizedBox(height: 4),
                  Text(message),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      final messageData = {
        'sender': userName,
        'message': messageController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      _firestore.collection('global').add(messageData).then((_) {
        messageController.clear();
      }).catchError((error) {
        // Handle error if any
        print("Error sending message: $error");
      });
    }
  }
}
