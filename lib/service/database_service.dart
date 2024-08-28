import 'package:canbea_flutter/models/club.dart';
import 'package:canbea_flutter/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _users;
  late final CollectionReference _clubs;

  final CollectionReference userRef =
      FirebaseFirestore.instance.collection("users");

  DatabaseService({this.uid}) {
    _users = _firestore.collection("users").withConverter<Users>(
        fromFirestore: (snapshot, _) => Users.fromJson(
              snapshot.data()!,
            ),
        toFirestore: (users, _) => users.toJson());
    _clubs = _firestore.collection("clubs").withConverter<Club>(
        fromFirestore: (snapshot, _) => Club.fromJson(
              snapshot.data()!,
            ),
        toFirestore: (clubs, _) => clubs.toJson());
  }

  Future getUserData(String id) async {
    QuerySnapshot snapshot = await _users.where("uid", isEqualTo: uid).get();
    return snapshot;
  }

  addUsers(Users users) async {
    _users.doc(uid).set(users);
    // _users.add(users);
  }

  updateUsers(String id, Users users) {
    _users.doc(id).update(users.toJson());
  }

  deleteUsers(String id) {
    _users.doc(id).delete();
  }

  Future gettingUserData() async {
    QuerySnapshot snapshot = await _users.where("uid", isEqualTo: uid).get();
    return snapshot;
  }

  Future<void> addClub(String clubName, Club clubs) async {
    try {
      // Add the club to the 'clubs' collection
      DocumentReference clubDocumentReference = await _clubs.add(clubs);

      await clubDocumentReference.update({"clubId": clubDocumentReference.id});

      // update current user's club with "${clubDocumentReference.id}_$clubName" value
      String clubValue = "${clubDocumentReference.id}_$clubName";

      // Update the current user's document in the 'users' collection

      DocumentReference userDocRef = _users.doc(uid);

      await userDocRef.update({
        'club': clubValue,
      });
    } catch (e) {
      print("Failed to add club: $e");
    }
  }

  Future gettingClubData(String id) async {
    QuerySnapshot snapshot = await _clubs.where("clubId", isEqualTo: id).get();
    return snapshot;
  }

  // Future toggleClubJoin(
  //   String clubId,
  //   String userName,
  //   String clubName,
  // ) async {
  //   DocumentReference userDocumentRefrence = _users.doc(uid);
  //   DocumentReference clubDocumentRefrence = _clubs.doc(clubId);

  //   DocumentSnapshot documentSnapshot = await userDocumentRefrence.get();
  //   String clubs = await documentSnapshot['club'];

  //   if (clubs.contains("${clubId}_$clubName")) {
  //     await userDocumentRefrence.update({'club': null});
  //     await clubDocumentRefrence.update({
  //       'members': FieldValue.arrayRemove(['${uid}_$userName'])
  //     });
  //   } else {
  //     await userDocumentRefrence.update({'clubs': '${clubId}_$clubName'});
  //     await clubDocumentRefrence.update({
  //       'members': FieldValue.arrayUnion(['${uid}_$userName'])
  //     });
  //   }
  // }

  Future<void> toggleClubJoin(
    String clubId,
    String userName,
    String clubName,
  ) async {
    DocumentReference userDocumentReference = _users.doc(uid);
    DocumentReference clubDocumentReference = _clubs.doc(clubId);

    // Get the user's document snapshot
    DocumentSnapshot userSnapshot = await userDocumentReference.get();
    // Retrieve the 'club' field as a string
    String? currentClub = userSnapshot['club'] as String?;

    if (currentClub != null && currentClub == "${clubId}_$clubName") {
      // If the user is already in the club, remove them
      await userDocumentReference.update({'club': null});
      await clubDocumentReference.update({
        'members': FieldValue.arrayRemove(['${uid}_$userName'])
      });
    } else {
      // If the user is not in the club, add them
      await userDocumentReference.update({'club': '${clubId}_$clubName'});
      await clubDocumentReference.update({
        'members': FieldValue.arrayUnion(['${uid}_$userName'])
      });
    }
  }

  getClubMembers(clubId) async {
    return _clubs.doc(clubId).snapshots();
  }

  // Future<bool> isUserJoined(
  //     String clubName, String clubId, String userName) async {
  //   DocumentReference userDocumentRefrennce = _users.doc(uid);
  //   DocumentSnapshot documentSnapshot = await userDocumentRefrennce.get();

  //   List<dynamic> clubs = await documentSnapshot['club'];
  //   if (clubs.contains("${clubId}_$clubName")) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future<bool> isUserJoined(
      String clubName, String clubId, String userName) async {
    DocumentReference userDocumentReference = _users.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    // Retrieve the 'club' field as a string
    String? club = documentSnapshot['club'] as String?;

    // Check if the clubId and clubName match the user's club
    if (club != null && club == "${clubId}_$clubName") {
      return true;
    } else {
      return false;
    }
  }

  searchByName(String clubName) {
    return _clubs.where("title", isEqualTo: clubName).get();
  }
}
