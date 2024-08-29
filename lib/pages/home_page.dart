import 'package:canbea_flutter/helper/helper_function.dart';
import 'package:canbea_flutter/pages/auth/login_page.dart';
import 'package:canbea_flutter/pages/bottom%20nav%20pages/channel_pages.dart';
import 'package:canbea_flutter/pages/bottom%20nav%20pages/club/find_club.dart';
import 'package:canbea_flutter/pages/bottom%20nav%20pages/club_page.dart';
import 'package:canbea_flutter/pages/chat%20pages/conversation_page.dart';
import 'package:canbea_flutter/pages/chat%20pages/search_page.dart';
import 'package:canbea_flutter/pages/onbording_page.dart';
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
  String updatedUserName = "";
  String email = "";
  String desc = "";
  String updatedDesc = "";
  String club = '';
  String userId = "";
  String avatar = "";

  Stream? rewards;

  String findUserName = "";

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
    await HelperFunction.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });

    // rewards = DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
    //     .getRewards();

    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getReward()
        .then((val) {
      setState(() {
        rewards = val;
      });
    });

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .gettingUserData()
        .then((val) {
      if (val.docs[0]['friends'].length >= 5) {
        DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .addRewards("assets/reward3.png");
      }
      setState(() {
        if (val.docs[0]['desc'] != null) {
          desc = val.docs[0]['desc'];
        } else {
          desc = "";
        }
        userName = val.docs[0]['userName'];
        avatar = val.docs[0]['avatarUrl'];
        userId = val.docs[0].id;
        if (val.docs[0]['club'] != null) {
          club = val.docs[0]['club'];
        } else {
          club = "_NO CLUB";
        }
      });
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  // void _closeEndDrawer() {
  //   Navigator.of(context).pop();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, ConversationsPage());
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
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(avatar),
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
                    title: const Text('Change Avatar'),
                    onTap: () {
                      nextScreen(context, const OnbordingPage());
                    },
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
                  CircleAvatar(
                    radius: 92,
                    backgroundImage:
                        NetworkImage(avatar), // Replace with your image URL
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      changeName(context);
                    },
                    child: Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      changeBio(context);
                    },
                    child: Container(
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
                        GestureDetector(
                          onTap: () {
                            goClub();
                          },
                          child: Row(
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            goClub();
                          },
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
                        // Row(
                        //   children: [
                        //     reward(),
                        //   ],
                        // ),
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
    return StreamBuilder(
        stream: rewards,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['reward'] != null) {
              if (snapshot.data['reward'].length != 0) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 80,
                  height: 110,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage(snapshot.data[0]['reward']),
                  ),
                );
              } else {
                return const Center(
                  child: Text("There are no reward."),
                );
              }
            } else {
              return const Center(
                child: Text("There are no reward."),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            );
          }
        });
  }

  // reward() {
  // return Container(
  //   margin: const EdgeInsets.all(8.0),
  //   width: 80,
  //   height: 110,
  //   decoration: BoxDecoration(
  //       color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
  //   child: Image.asset(
  //     "assets/reward1.png", // Make sure imagePath is a valid path in your assets
  //     fit: BoxFit.cover,
  //   ),
  // );
  // }

  goClub() {
    if (club == "_NO CLUB") {
      nextScreen(context, FindClub(userName: userName));
    } else {
      nextScreen(context, ClubPage(clubId: getId(club)));
    }
  }

  changeBio(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Change Your Bio",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                          ),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              updatedDesc = val;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.amber),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        )
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style:
                      ElevatedButton.styleFrom(foregroundColor: Colors.amber),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (updatedDesc.length <= 40) {
                      if (updatedDesc != "") {
                        setState(() {
                          _isLoading = true;
                        });
                        DatabaseService(
                                uid: FirebaseAuth.instance.currentUser!.uid)
                            .updateBio(updatedDesc)
                            .whenComplete(() {
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.of(context).pop();
                          showSnackBar(context, Colors.amber,
                              "Bio Successfully changed");
                        });
                      }
                    } else {
                      Navigator.of(context).pop();
                      showSnackBar(context, Colors.red,
                          "Bio is too long make it 40 characters");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white),
                  child: const Text("Save"),
                ),
              ],
            );
          }));
        });
  }

  changeName(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Change Your Username",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.amber,
                          ),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              updatedUserName = val;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.amber),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        )
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style:
                      ElevatedButton.styleFrom(foregroundColor: Colors.amber),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await DatabaseService()
                        .gettingUserName(updatedUserName)
                        .then((val) {
                      setState(() {
                        if (val.docs.isNotEmpty) {
                          findUserName = val.docs[0]['userName'];
                          // Handle the case where a user is found
                        } else {
                          findUserName = "no_!@user@!_found";
                        }
                      });
                    });

                    if (findUserName != updatedUserName) {
                      if (updatedUserName.length <= 40) {
                        if (updatedUserName != "") {
                          setState(() {
                            _isLoading = true;
                          });
                          DatabaseService(
                                  uid: FirebaseAuth.instance.currentUser!.uid)
                              .updateUsername(updatedUserName)
                              .whenComplete(() {
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.of(context).pop();
                            showSnackBar(context, Colors.amber,
                                "Username Successfully changed");
                          });
                        }
                      } else {
                        Navigator.of(context).pop();
                        showSnackBar(context, Colors.red,
                            "Username is too long make it 20 characters");
                      }
                    } else {
                      Navigator.of(context).pop();
                      showSnackBar(
                          context, Colors.red, "Username already exist");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white),
                  child: const Text("Save"),
                ),
              ],
            );
          }));
        });
  }
}
