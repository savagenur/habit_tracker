import 'dart:io';

import 'package:habit_tracker/features/domain/entities/user/user_entity.dart';

import '../entities/habit/habit_entity.dart';

abstract class FirebaseRepository {
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

  // Habit
  Future<void> loadDataHabit();
  Future<String?> getStartedAt();
  Future<void> copyCollection(
      {required sourceCollection,
      required destCollection,
      bool isNewDay = false,
      bool isDelete = false});
  Future<void> updateDatabaseHabit();
  Future<List> getListOfCollHabit();
  Future<void> createHabit({required HabitEntity habitEntity});
  Future<void> updateHabit(HabitEntity habitEntity,String day,String habitId, bool isChangedOnlyCheckBool);
  Future<void> deleteHabit(String habitId);
  Stream<List<HabitEntity>> getHabits(String uid,String dayString);

  // Calendar
  Future<Map> getCalendarDoneMap(String uid);
}
