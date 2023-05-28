import 'dart:io';

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? uid;
  final String? username;
  final String? name;
  final String? email;
  final String? profileUrl;
  final num? totalHabits;

  // will not store in db
  final File? imageFile;
  final String? password;

  const UserEntity({
    this.uid,
    this.username,
    this.name,
    this.email,
    this.profileUrl,
    this.totalHabits,
    this.imageFile,
    this.password,
  });

  @override
  List<Object?> get props => [
        uid,
        username,
        name,
        email,
        profileUrl,
        totalHabits,
        password,
        imageFile,
      ];
}
