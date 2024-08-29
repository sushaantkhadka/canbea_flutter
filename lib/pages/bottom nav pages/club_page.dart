import 'package:canbea_flutter/helper/helper_function.dart';
import 'package:canbea_flutter/pages/home_page.dart';
import 'package:canbea_flutter/service/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClubPage extends StatefulWidget {
  final String clubId;
  const ClubPage({super.key, required this.clubId});

  @override
  State<ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  Stream? members;
  String clubName = "";
  String clubDesc = "";
  String userName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClubData();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  getClubData() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .gettingUserData()
        .then((val) {
      setState(() {
        userName = val.docs[0]['userName'];
      });
    });

    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getClubMembers(widget.clubId)
        .then((val) {
      setState(() {
        members = val;
      });
    });

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .gettingClubData(widget.clubId)
        .then((val) {
      if (val.docs[0] != null) {
        setState(() {
          clubName = val.docs[0]["title"];
          if (val.docs[0]["desc"] != null) {
            clubDesc = val.docs[0]["desc"];
          }
        });
      } else {
        clubName = "Club";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg3.png"), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.yellow[700],
          centerTitle: true,
          title: Text(
            clubName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: _body(),
      ),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(color: Colors.grey[100]),
        child: Column(
          children: [
            Text(
              "Welcome to ${clubName}",
              style: TextStyle(
                  color: Colors.yellow[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Discription",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            Text(clubDesc),
            exitGroup(),
            SizedBox(
              height: 50,
            ),
            Text(
              "Club Members",
              style: TextStyle(
                  color: Colors.yellow[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['members'] != null) {
              if (snapshot.data['members'].length != 0) {
                return ListView.builder(
                  itemCount: snapshot.data['members'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.amber,
                          child: Text(
                            getName(snapshot.data['members'][index])
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        title: Text(
                          getName(snapshot.data['members'][index]),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        subtitle: const Text("Member"),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("There are no members."),
                );
              }
            } else {
              return const Center(
                child: Text("There are no members."),
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

  exitGroup() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      child: const Text('Leave Club'),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Leave Club"),
                content: const Text("Are you sure you want Leave the club?"),
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
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .toggleClubJoin(widget.clubId, userName, clubName);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
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
    );
  }
}
