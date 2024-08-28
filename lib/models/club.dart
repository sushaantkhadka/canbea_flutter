import 'package:cloud_firestore/cloud_firestore.dart';

class Club {
  String? clubId;
  String? clubIcon;
  String title;
  String? desc;
  String admin;
  List<dynamic> members;

  Club({
    this.clubId,
    this.clubIcon,
    required this.title,
    this.desc,
    required this.admin,
    required this.members,
  });

  Club.fromJson(Map<String, Object?> json)
      : this(
          clubId: json["clubId"]! as String,
          clubIcon: json["clubIcon"]! as String,
          title: json["title"]! as String,
          desc: json["desc"]! as String,
          admin: json["admin"]! as String,
          members: json["members"]! as List<dynamic>,
        );

  Club copyWith({
    String? clubId,
    String? clubIcon,
    String? title,
    String? desc,
    String? admin,
    List<dynamic>? members,
  }) {
    return Club(
        clubId: clubId ?? this.clubId,
        clubIcon: clubIcon ?? this.clubIcon,
        title: title ?? this.title,
        desc: desc ?? this.desc,
        admin: admin ?? this.admin,
        members: members ?? this.members);
  }

  Map<String, Object?> toJson() {
    return {
      "clubId": clubId,
      "clubIcon": clubIcon,
      "title": title,
      "desc": desc,
      "admin": admin,
      "members": members
    };
  }
}
