import 'package:canbea_flutter/models/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _users;

  DatabaseService({this.uid}) {
    _users = _firestore.collection("users").withConverter<Users>(
        fromFirestore: (snapshot, _) => Users.fromJson(
              snapshot.data()!,
            ),
        toFirestore: (users, _) => users.toJson());
  }

  Stream<QuerySnapshot> getUsers() {
    return _users.snapshots();
  }

  void addUsers(Users users) async {
    _users.add(users);
  }

  Future gettingUserData() async {
    QuerySnapshot snapshot = await _users.where("uid", isEqualTo: uid).get();
    return snapshot;
  }
}
