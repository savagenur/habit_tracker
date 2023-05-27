import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? uid;
  final String? username;
  final String? name;
  final String? email;
  final String? profileUrl;
  final num? totalHabits;

  const UserEntity({
    this.uid,
    this.username,
    this.name,
    this.email,
    this.profileUrl,
    this.totalHabits,
  });

  @override
  List<Object?> get props => [
        uid,
        username,
        name,
        email,
        profileUrl,
        totalHabits,
      ];
}
