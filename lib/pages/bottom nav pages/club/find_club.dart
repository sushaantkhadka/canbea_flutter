import 'package:canbea_flutter/models/club.dart';
import 'package:canbea_flutter/pages/bottom%20nav%20pages/club_page.dart';
import 'package:canbea_flutter/service/database_service.dart';
import 'package:canbea_flutter/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FindClub extends StatefulWidget {
  final String userName;
  const FindClub({super.key, required this.userName});

  @override
  State<FindClub> createState() => _FindClubState();
}

class _FindClubState extends State<FindClub> {
  TextEditingController searchController = TextEditingController();

  // User? user;

  String user = FirebaseAuth.instance.currentUser!.uid;
  bool isJoined = false;

  bool _isLoading = false;
  String clubName = "";
  String userId = "";
  DatabaseService databaseService = DatabaseService();

  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  getUserId() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .gettingUserData()
        .then((val) {
      setState(() {
        userId = val.docs[0].id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Colors.amber,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.yellow[700],
      centerTitle: true,
      title: const Text(
        "Find a club",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  _body() {
    return Column(
      children: [
        Container(
          color: Colors.amber,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search...",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  initiateSearchMethod();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(40)),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              )
            : clubList(),
      ],
    );
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseService()
          .searchByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          _isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  clubList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return clubTile(
                widget.userName,
                searchSnapshot!.docs[index]['clubId'],
                searchSnapshot!.docs[index]['title'],
                searchSnapshot!.docs[index]['admin'],
              );
            },
          )
        : Container();
  }

  joinValue(
      String userName, String clubId, String clubName, String admin) async {
    await DatabaseService(uid: user)
        .isUserJoined(clubName, clubId, userName)
        .then((value) {
      if (mounted) {
        // Check if the widget is still in the widget tree
        setState(() {
          isJoined = value;
        });
      }
    });
  }

  Widget clubTile(
      String userName, String clubId, String clubName, String admin) {
    joinValue(userName, clubId, clubName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.amber,
        child: Text(
          clubName.substring(0, 1).toUpperCase(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        getName(clubName),
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
      ),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user)
              .toggleClubJoin(clubId, userName, clubName);
          if (isJoined) {
            setState(() {
              isJoined = !isJoined;
            });
            showSnackBar(context, Colors.amber, "Sucessfully joined the club.");
            Future.delayed(Duration(seconds: 2), () {
              nextScreen(context, ClubPage(clubId: clubId));
            });
          } else {
            showSnackBar(context, Colors.red, "Sucessfully left the club.");
          }
        },
        child: isJoined
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 1)),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: const Text(
                  "Joined",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber,
                    border: Border.all(color: Colors.white, width: 1)),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: const Text(
                  "Join",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Create a Club",
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
                              clubName = val;
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
                    if (clubName != "") {
                      setState(() {
                        _isLoading = true;
                      });

                      Club clubs = Club(
                          title: clubName,
                          clubIcon: "assets/crown.png",
                          admin: "${userId}_${widget.userName}",
                          members: ["${userId}_${widget.userName}"]);
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .addClub(clubName, clubs)
                          .whenComplete(() {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.of(context).pop();
                        showSnackBar(
                            context, Colors.amber, "Club Sucessfully Created");
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white),
                  child: const Text("CREATE"),
                ),
              ],
            );
          }));
        });
  }
}
