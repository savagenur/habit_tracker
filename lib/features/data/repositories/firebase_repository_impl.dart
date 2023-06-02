import 'dart:io';

import 'package:habit_tracker/features/data/datasources/remote_data_source/remote_data_source.dart';
import 'package:habit_tracker/features/domain/entities/habit/habit_entity.dart';
import 'package:habit_tracker/features/domain/entities/user/user_entity.dart';
import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseRemoteDataSource remoteDataSource;
  FirebaseRepositoryImpl({
    required this.remoteDataSource,
  });
  @override
  Future<void> createUser(UserEntity userEntity) async =>
      remoteDataSource.createUser(userEntity);

  @override
  Future<String> getCurrentUid() async => remoteDataSource.getCurrentUid();

  @override
  Stream<List<UserEntity>> getUser(String uid) => remoteDataSource.getUser(uid);

  @override
  Future<bool> isSignIn() async => remoteDataSource.isSignIn();
  @override
  Future<void> signInUser(UserEntity userEntity) async =>
      remoteDataSource.signInUser(userEntity);

  @override
  Future<void> signOut() async => remoteDataSource.signOut();

  @override
  Future<void> signUpUser(UserEntity userEntity) async =>
      remoteDataSource.signUpUser(userEntity);

  @override
  Future<void> updateUser(UserEntity userEntity) async =>
      remoteDataSource.updateUser(userEntity);

  @override
  Future<void> createUserWithImage(UserEntity userEntity, String profileUrl) {
    return remoteDataSource.createUserWithImage(userEntity, profileUrl);
  }

  @override
  Future<String> uploadImageToStorage(File? file, String childName) async {
    return remoteDataSource.uploadImageToStorage(file, childName);
  }

  @override
  Future<void> resetPassword(String email) {
    return remoteDataSource.resetPassword(email);
  }

  @override
  Future<void> copyCollection(
      {required sourceCollection,
      required destCollection,
      bool isNewDay = false,bool isDelete=false}) async {
    return remoteDataSource.copyCollection(
        sourceCollection: sourceCollection,
        destCollection: destCollection,
        );
  }

  @override
  Future<void> createHabit({required HabitEntity habitEntity}) async {
    return remoteDataSource.createHabit(habitEntity: habitEntity);
  }

  @override
  Future<void> deleteHabit(String habitId) async =>
      remoteDataSource.deleteHabit(habitId);

  @override
  Stream<List<HabitEntity>> getHabits(String uid)  => remoteDataSource.getHabits(uid);

  @override
  Future<List> getListOfCollHabit() async =>
      remoteDataSource.getListOfCollHabit();

  @override
  Future<String?> getStartedAt() async => remoteDataSource.getStartedAt();

  @override
  Future<void> loadDataHabit() async => remoteDataSource.loadDataHabit();

  @override
  Future<void> updateDatabaseHabit() async =>
      remoteDataSource.updateDatabaseHabit();

  @override
  Future<void> updateHabit(HabitEntity habitEntity) async =>
      remoteDataSource.updateHabit(habitEntity);
}
