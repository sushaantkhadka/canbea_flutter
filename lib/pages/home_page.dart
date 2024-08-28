import 'package:canbea_flutter/helper/helper_function.dart';
import 'package:canbea_flutter/pages/auth/login_page.dart';
import 'package:canbea_flutter/pages/bottom%20nav%20pages/channel_pages.dart';
import 'package:canbea_flutter/pages/bottom%20nav%20pages/club/find_club.dart';
import 'package:canbea_flutter/pages/bottom%20nav%20pages/club_page.dart';
import 'package:canbea_flutter/pages/bottom%20nav%20pages/search_page.dart';
import 'package:canbea_flutter/pages/socialPages/chat_page.dart';
import 'package:canbea_flutter/pages/bottom%20nav%20pages/task_page.dart';
import 'package:canbea_flutter/service/auth_service.dart';
import 'package:canbea_flutter/service/database_service.dart';
import 'package:canbea_flutter/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();

  String userName = "";
  String email = "";
  String desc = "";
  String club = '';
  String userId = "";

  bool _isLoading = false;
  String groupName = "";

  Stream? userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  Future<void> gettingUserData() async {
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });

    await HelperFunction.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .gettingUserData()
        .then((val) {
      setState(() {
        if (val.docs[0]['desc'] != null) {
          desc = val.docs[0]['desc'];
        } else {
          desc = "";
        }

        userId = val.docs[0].id;
        if (val.docs[0]['club'] != null) {
          club = val.docs[0]['club'];
        } else {
          club = "_NO CLUB";
        }
      });
    });

    // print("get id is ${getId(club)}");
    // await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
    //     .getUserGroup()
    //     .then((snapshot) {
    //   setState(() {
    //     groups = snapshot;
    //   });
    // });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const ChatPage());
              },
              icon: const Icon(Icons.group)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          IconButton(
              onPressed: () {
                _openEndDrawer();
              },
              icon: const Icon(Icons.segment)),
        ],
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () async {
            setting();
          },
        ),
        backgroundColor: Colors.yellow[700],
        centerTitle: true,
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: AssetImage("assets/imagepic.png"),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          userName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 2,
                  ),
                  ListTile(
                    leading: const Icon(Icons.message),
                    title: const Text('Messages'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text('Profile'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 92,
                    backgroundImage: NetworkImage(
                        'https://img.freepik.com/premium-photo/anime-boy-aesthetic-image-wallpaper_590614-6502.jpg'), // Replace with your image URL
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 2), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: Text(
                        desc,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(24)),
                        child: const Column(
                          children: [
                            Text("POPULARITY",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '150',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(24)),
                        child: const Column(
                          children: [
                            Text("POPULARITY",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '150',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(24)),
                        child: const Column(
                          children: [
                            Text("POPULARITY",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '150',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.white)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey[100],
                              backgroundImage:
                                  const AssetImage("assets/crown.png"),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "CLUB",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(getName(club)),
                                Text(
                                  "-",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.chevron_right),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 1, color: Colors.white)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.yellow[700],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Rewards",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  "View All",
                                  style: TextStyle(fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            reward(),
                            reward(),
                            reward(),
                            reward(),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      endDrawerEnableOpenDragGesture: false,
      bottomNavigationBar: BottomAppBar(
        color: Colors.yellow[700],
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                onPressed: () {
                  nextScreen(context, const TaskPage());
                },
                icon: const Icon(
                  Icons.content_paste,
                  color: Colors.black,
                  size: 32.0,
                )),
            IconButton(
              onPressed: () {
                nextScreen(context, SearchPage());
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
                size: 32,
              ),
            ),
            IconButton(
                onPressed: () {
                  goClub();
                },
                icon: const Icon(
                  Icons.stars,
                  color: Colors.black,
                  size: 32,
                )),
            IconButton(
                onPressed: () {
                  nextScreen(context, const ChannelPages());
                },
                icon: const Icon(
                  Icons.phone_android,
                  color: Colors.black,
                  size: 32,
                )),
          ],
        ),
      ),
    );
  }

  setting() {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Logout'),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Logout"),
                            content:
                                const Text("Are you sure you want to logout?"),
                            actions: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await authService.logOut();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (route) => false);
                                },
                                icon: const Icon(
                                  Icons.exit_to_app,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  reward() {
    return Container(
      margin: const EdgeInsets.all(1),
      width: 80,
      height: 110,
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
      child: const Image(
        image: AssetImage("assets/reward1.png"),
      ),
    );
  }

  goClub() {
    if (club == "_NO CLUB") {
      nextScreen(context, FindClub(userName: userName));
    } else {
      nextScreen(context, ClubPage(clubId: getId(club)));
    }
  }
}
