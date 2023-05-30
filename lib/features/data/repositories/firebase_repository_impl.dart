import 'dart:io';

import 'package:habit_tracker/features/data/datasources/remote_data_source/remote_data_source.dart';
import 'package:habit_tracker/features/domain/entities/user_entity.dart';
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
}
