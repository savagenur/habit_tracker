import 'package:habit_tracker/features/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel extends UserEntity {
  final String? uid;
  final String? username;
  final String? name;
  final String? email;
  final String? profileUrl;
  final num? totalHabits;
  const UserModel({
    this.uid,
    this.username,
    this.name,
    this.email,
    this.profileUrl,
    this.totalHabits,
  }) : super(
          uid: uid,
          name: name,
          username: username,
          email: email,
          profileUrl: profileUrl,
          totalHabits: totalHabits,
        );

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      uid: snapshot["uid"],
      username: snapshot["username"],
      name: snapshot["name"],
      email: snapshot["email"],
      profileUrl: snapshot["profileUrl"],
      totalHabits: snapshot["totalHabits"],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "username": username,
      "name": name,
      "email": email,
      "profileUrl": profileUrl,
      "totalHabits": totalHabits,
    };
  }
}
