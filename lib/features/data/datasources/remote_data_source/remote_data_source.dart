import 'dart:io';

import 'package:habit_tracker/features/domain/entities/user_entity.dart';

abstract class FirebaseRemoteDataSource {
  // Credential
  Future<void> signUpUser(UserEntity userEntity);
  Future<void> signInUser(UserEntity userEntity);
  Future<bool> isSignIn();
  Future<void> signOut();

  // User
  Future<String> getCurrentUid();
  Stream<List<UserEntity>> getUser(String uid);
  Future<void> createUser(UserEntity userEntity);
  Future<void> createUserWithImage(UserEntity userEntity, String profileUrl);
  Future<void> updateUser(UserEntity userEntity);
  Future<void> resetPassword(String email);

  // Storage
  Future<String> uploadImageToStorage(File? file, String childName);
}
