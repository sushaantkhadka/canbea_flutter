import 'package:canbea_flutter/pages/home_page.dart';
import 'package:canbea_flutter/pages/socialPages/chat_page.dart';
import 'package:canbea_flutter/pages/socialPages/friends_page.dart';
import 'package:canbea_flutter/service/database_service.dart';
import 'package:canbea_flutter/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WallPage extends StatefulWidget {
  const WallPage({super.key});

  @override
  State<WallPage> createState() => _WallPageState();
}

class _WallPageState extends State<WallPage> {
  Stream<QuerySnapshot>? chats;

  TextEditingController messageController = TextEditingController();

  String userName = "";

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .gettingUserData()
        .then((val) {
      setState(() {
        userName = val.docs[0]['userName'];
      });
      print("username ${userName}");
    });

    DatabaseService().getWalls(uid).then((val) {
      setState(() {
        chats = val;
        print('chat data ${chats}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            nextScreenRemoveBack(context, HomePage());
          },
        ),
        backgroundColor: Colors.yellow[700],
        centerTitle: true,
        title: const Text(
          'Friends',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 50, bottom: 90),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    walls(),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              width: double.infinity,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[400],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 2), // changes position of shadow
                              ),
                            ]),
                        child: const Text(
                          "Wall",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        nextScreen(context, FriendsPage());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 2), // changes position of shadow
                              ),
                            ]),
                        child: const Text(
                          "Friends",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        nextScreen(context, ChatPage());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 2), // changes position of shadow
                              ),
                            ]),
                        child: const Text(
                          "chat",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": userName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendWall(uid, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }

  Widget walls() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final wall = snapshot.data!.docs;

        return ListView.builder(
          itemCount: wall.length,
          itemBuilder: (context, index) {
            final chatData = wall[index].data() as Map<String, dynamic>;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage("assets/imagepic.png"),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chatData['sender'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        chatData['message'],
                        overflow: TextOverflow.visible,
                        softWrap: true,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle wall tap action
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        "Wall",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // walls() {
  //   return StreamBuilder(
  //       stream: chats,
  //       builder: (context, AsyncSnapshot snapshot) {
  //         return snapshot.hasData
  //             ? ListView.builder(
  //                 itemCount: snapshot.data.docs.length,
  //                 itemBuilder: (context, index) {
  //                   return Container(
  //                       margin: const EdgeInsets.symmetric(
  //                           horizontal: 20, vertical: 4),
  //                       padding: const EdgeInsets.symmetric(
  //                           vertical: 10, horizontal: 10),
  //                       width: double.infinity,
  //                       decoration: BoxDecoration(
  //                           color: Colors.grey[100],
  //                           borderRadius: BorderRadius.circular(12),
  //                           boxShadow: [
  //                             BoxShadow(
  //                               color: Colors.grey.withOpacity(0.2),
  //                               spreadRadius: 2,
  //                               blurRadius: 5,
  //                               offset: const Offset(
  //                                   0, 2), // changes position of shadow
  //                             ),
  //                           ]),
  //                       child: Row(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           const CircleAvatar(
  //                             radius: 24,
  //                             backgroundImage:
  //                                 AssetImage("assets/imagepic.png"),
  //                           ),
  //                           const SizedBox(
  //                             width: 10,
  //                           ),
  //                           Expanded(
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Text(
  //                                   snapshot.data.docs[index]['sender'],
  //                                   style: const TextStyle(
  //                                       fontSize: 18,
  //                                       fontWeight: FontWeight.bold),
  //                                 ),
  //                                 Text(
  //                                   snapshot.data.docs[index]['message'],
  //                                   overflow: TextOverflow.visible,
  //                                   softWrap: true,
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           GestureDetector(
  //                             onTap: () {},
  //                             child: Container(
  //                               padding: const EdgeInsets.symmetric(
  //                                   horizontal: 15, vertical: 4),
  //                               decoration: BoxDecoration(
  //                                   color: Colors.green,
  //                                   borderRadius: BorderRadius.circular(16)),
  //                               child: const Text(
  //                                 "Wall",
  //                                 style: TextStyle(
  //                                     color: Colors.white,
  //                                     fontWeight: FontWeight.w600,
  //                                     fontSize: 14),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ));
  //                 },
  //               )
  //             : Container();
  //       });
  // }

  // walls() {
  //   return Container(
  //       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
  //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //           color: Colors.grey[100],
  //           borderRadius: BorderRadius.circular(12),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.grey.withOpacity(0.2),
  //               spreadRadius: 2,
  //               blurRadius: 5,
  //               offset: const Offset(0, 2), // changes position of shadow
  //             ),
  //           ]),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           const CircleAvatar(
  //             radius: 24,
  //             backgroundImage: AssetImage("assets/imagepic.png"),
  //           ),
  //           const SizedBox(
  //             width: 10,
  //           ),
  //           const Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'Narata',
  //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //                 ),
  //                 Text(
  //                   "To be the customer’s preferred choice forproviding construction services",
  //                   overflow: TextOverflow.visible,
  //                   softWrap: true,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           GestureDetector(
  //             onTap: () {},
  //             child: Container(
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
  //               decoration: BoxDecoration(
  //                   color: Colors.green,
  //                   borderRadius: BorderRadius.circular(16)),
  //               child: const Text(
  //                 "Wall",
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.w600,
  //                     fontSize: 14),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ));
  // }
}
