import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String uid;
  String userName;
  String email;
  String? avatarUrl;
  String? desc;
  String? club;
  List<dynamic>? reward;
  List<dynamic>? friends;
  Timestamp createdOn;
  Timestamp updatedOn;

  Users({
    required this.uid,
    required this.userName,
    required this.email,
    this.avatarUrl,
    this.desc,
    this.club,
    this.reward,
    this.friends,
    required this.createdOn,
    required this.updatedOn,
  });

  Users.fromJson(Map<String, Object?> json)
      : this(
          uid: json["uid"]! as String,
          userName: json["userName"]! as String,
          email: json["email"]! as String,
          avatarUrl: json["avatarUrl"] as String?,
          desc: json["desc"] as String?,
          club: json["club"] as String?,
          reward: json["reward"] as List<dynamic>?,
          friends: json["friends"] as List<dynamic>?,
          createdOn: json["createdOn"]! as Timestamp,
          updatedOn: json["updatedOn"]! as Timestamp,
        );

  Users copyWith({
    String? uid,
    String? userName,
    String? email,
    String? avatarUrl,
    String? desc,
    String? club,
    List<dynamic>? reward,
    List<dynamic>? friends,
    Timestamp? createdOn,
    Timestamp? updatedOn,
  }) {
    return Users(
        uid: uid!,
        userName: userName ?? this.userName,
        email: email ?? this.email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        desc: desc ?? this.desc,
        club: club ?? this.club,
        reward: reward ?? this.reward,
        friends: friends ?? this.friends,
        createdOn: createdOn ?? this.createdOn,
        updatedOn: updatedOn ?? this.updatedOn);
  }

  Map<String, Object?> toJson() {
    return {
      "uid": uid,
      "userName": userName,
      "email": email,
      "avatarUrl": avatarUrl,
      "desc": desc,
      "club": club,
      "reward": reward,
      "friends": friends,
      "createdOn": createdOn,
      "updatedOn": updatedOn,
    };
  }
}
