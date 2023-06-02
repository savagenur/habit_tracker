import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:habit_tracker/constants.dart';

import 'package:habit_tracker/features/data/datasources/remote_data_source/remote_data_source.dart';
import 'package:habit_tracker/features/data/models/user/user_model.dart';
import 'package:habit_tracker/features/domain/entities/habit/habit_entity.dart';
import 'package:habit_tracker/features/domain/entities/user/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../../date_time.dart';
import '../../../../injection_container.dart';
import '../../models/habit/habit_model.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  FirebaseRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.firebaseStorage,
  });
  @override
  Future<void> createUser(UserEntity userEntity) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    final uid = await getCurrentUid();
    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        username: userEntity.username,
        name: userEntity.name,
        email: userEntity.email,
        profileUrl: userEntity.profileUrl,
        totalHabits: userEntity.totalHabits,
      ).toJson();
      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      toast("Error: $error");
    });
  }

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;

  @override
  Stream<List<UserEntity>> getUser(String uid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConst.users)
        .where("uid", isEqualTo: uid)
        .limit(1);
    return userCollection.snapshots().map((querySnapshot) => querySnapshot.docs
        .map((snap) => UserModel.fromSnapshot(snap))
        .toList());
  }

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> signInUser(UserEntity userEntity) async {
    try {
      if (userEntity.email!.isNotEmpty && userEntity.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: userEntity.email!, password: userEntity.password!);
      } else {
        toast("Fields can't be empty");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        toast(e.code);
        print(e.code);
      }
      if (e.code == "invalid-email") {
        toast("Invalid email");
      }
      if (e.code == "wrong-password") {
        toast("Invalid email or password!");
      } else {
        toast(e.code);
      }
    }
  }

  @override
  Future<void> signOut() async => await firebaseAuth.signOut();

  @override
  Future<void> signUpUser(UserEntity userEntity) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(
              email: userEntity.email!, password: userEntity.password!)
          .then((currentUser) {
        if (currentUser.user?.uid != null) {
          if (userEntity.imageFile != null) {
            uploadImageToStorage(userEntity.imageFile, "profileImages")
                .then((profileUrl) {
              createUserWithImage(userEntity, profileUrl);
            });
          } else {
            createUserWithImage(userEntity, "");
          }
        }
      });
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        toast("Email is already taken!");
      } else {
        toast("Oops, something went wrong!");
      }
    }
  }

  @override
  Future<void> updateUser(UserEntity userEntity) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    Map<String, dynamic> userInformation = {};
    if (userEntity.name != null && userEntity.name != '') {
      userInformation['name'] = userEntity.name;
    }
    if (userEntity.username != null && userEntity.username != '') {
      userInformation['username'] = userEntity.username;
    }
    if (userEntity.profileUrl != null && userEntity.profileUrl != '') {
      userInformation['profileUrl'] = userEntity.profileUrl;
    }
    userCollection.doc(userEntity.uid).update(userInformation);
  }

  @override
  Future<String> uploadImageToStorage(File? file, String childName) async {
    Reference ref = firebaseStorage
        .ref()
        .child(childName)
        .child(firebaseAuth.currentUser!.uid);
    final uploadTask = ref.putFile(file!);
    final imageUrl =
        (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return await imageUrl;
  }

  @override
  Future<void> createUserWithImage(
      UserEntity userEntity, String profileUrl) async {
    final userCollection = firebaseFirestore.collection(FirebaseConst.users);
    final uid = await getCurrentUid();
    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        username: userEntity.username,
        name: userEntity.name,
        email: userEntity.email,
        profileUrl: profileUrl,
        totalHabits: userEntity.totalHabits,
      ).toJson();
      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      toast("Error: $error");
    });
  }

  @override
  Future<void> resetPassword(String email) async {
    return await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> copyCollection(
      {required sourceCollection,
      required destCollection,
      bool isNewDay = false,
      bool isDelete = false}) async {
    final querySnapshot = await sourceCollection.get();

    final batch = FirebaseFirestore.instance.batch();

    for (final doc in querySnapshot.docs) {
      final data = doc.data();
      if (isNewDay) {
        data["isCompleted"] = false;
      }
      batch.set(destCollection.doc(doc.id), data);
    }

    await batch.commit();
  }

  @override
  Future<void> createHabit({required HabitEntity habitEntity}) async {
    final uid = await getCurrentUid();
    final todaysHabitList = firebaseFirestore
        .collection(FirebaseConst.habits)
        .doc(uid)
        .collection(FirebaseConst.todaysHabitList);

    try {
      final habitUid = const Uuid().v1();
      final newHabit = HabitModel(
        createdAt: Timestamp.now(),
        habitId: habitUid,
        isCompleted: habitEntity.isCompleted,
        title: habitEntity.title,
        description: habitEntity.description,
        executionFrequency: habitEntity.executionFrequency,
        color: habitEntity.color,
      ).toJson();

      await todaysHabitList.doc(habitUid).set(newHabit);

      await updateDatabaseHabit();
    } catch (error) {
      toast(error.toString());
    }
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    final uid = await getCurrentUid();
    
    final collectionPaths = await getListOfCollHabit();
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (String path in collectionPaths) {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection("habits")
          .doc(uid)
          .collection(path)
          .doc(habitId);
      batch.delete(docRef);
    }
    await batch.commit();
  }

  @override
  Stream<List<HabitEntity>> getHabits(String uid) {
    final todaysHabitList = firebaseFirestore
        .collection(FirebaseConst.habits)
        .doc(uid)
        .collection(FirebaseConst.todaysHabitList);

    return todaysHabitList
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((querySnapshot) =>
            querySnapshot.docs.map((e) => HabitModel.fromSnapshot(e)).toList());
  }

  @override
  Future<List> getListOfCollHabit() async {
    final habitsCollection = firebaseFirestore.collection(FirebaseConst.habits);
    final uid = await getCurrentUid();
    List newCollectionList = [];

    await habitsCollection.doc(uid).get().then((doc) {
      newCollectionList = doc["collectionList"];
    });
    return newCollectionList;
  }

  @override
  Future<String?> getStartedAt() async {
    final sharedPreferences = sl.get<SharedPreferences>();
    final String? startedAt = sharedPreferences.getString("startedAt");
    return startedAt;
  }

  @override
  Future<void> loadDataHabit() async {
    final uid = await getCurrentUid();
    final todaysHabitList = firebaseFirestore
        .collection(FirebaseConst.habits)
        .doc(uid)
        .collection(FirebaseConst.todaysHabitList);
    final habitsCollection = firebaseFirestore.collection(FirebaseConst.habits);
    final todaysDateFormattedListCollection = firebaseFirestore
        .collection(FirebaseConst.habits)
        .doc(uid)
        .collection(todaysDateFormatted());
    final currentHabitListCollection = firebaseFirestore
        .collection(FirebaseConst.habits)
        .doc(uid)
        .collection(FirebaseConst.currentHabitList);
    final SharedPreferences sharedPreferences = sl.get<SharedPreferences>();

    var habitsDoc = await habitsCollection.doc(uid).get();

    if (!habitsDoc.exists) {
      sharedPreferences.setString("startedAt", todaysDateFormatted());
      await habitsCollection.doc(uid).set({
        "startedAt": todaysDateFormatted(),
        "collectionList": [
          "todaysHabitList",
          "currentHabitList",
          todaysDateFormatted()
        ]
      });
    }
    final collectionList = await getListOfCollHabit();

    if (!collectionList.contains(todaysDateFormatted())) {
      await habitsCollection.doc(uid).update({
        "collectionList": collectionList
          ..add(
            todaysDateFormatted(),
          ),
      });
      await copyCollection(
          sourceCollection: currentHabitListCollection,
          destCollection: todaysHabitList,
          isNewDay: true);
    } else {
      await copyCollection(
        sourceCollection: todaysDateFormattedListCollection,
        destCollection: todaysHabitList,
      );
    }
    await getStartedAt();

    await updateDatabaseHabit();
  }

  @override
  Future<void> updateDatabaseHabit() async {
    final uid = await getCurrentUid();
    final todaysHabitList = firebaseFirestore
        .collection(FirebaseConst.habits)
        .doc(uid)
        .collection("todaysHabitList");
    final todaysDateFormattedListCollection = firebaseFirestore
        .collection(FirebaseConst.habits)
        .doc(uid)
        .collection(todaysDateFormatted());
    final currentHabitListCollection = firebaseFirestore
        .collection(FirebaseConst.habits)
        .doc(uid)
        .collection(FirebaseConst.currentHabitList);
    await copyCollection(
      sourceCollection: todaysHabitList,
      destCollection: todaysDateFormattedListCollection,
    );
    await copyCollection(
      sourceCollection: todaysHabitList,
      destCollection: currentHabitListCollection,
    );
  }

  @override
  Future<void> updateHabit(HabitEntity habitEntity) async {
    final uid = await getCurrentUid();
    final todaysHabitList = firebaseFirestore
        .collection(FirebaseConst.habits)
        .doc(uid)
        .collection(FirebaseConst.todaysHabitList);

    Map<String, dynamic> habitInformation = {};
    if (habitEntity.title != '' && habitEntity.title != null) {
      habitInformation['title'] = habitEntity.title;
    }
    if (habitEntity.description != '' && habitEntity.description != null) {
      habitInformation['description'] = habitEntity.description;
    }
    // ignore: unrelated_type_equality_checks
    if (habitEntity.isCompleted != '' && habitEntity.isCompleted != null) {
      habitInformation['isCompleted'] = habitEntity.isCompleted;
    }

    try {
      await todaysHabitList.doc(habitEntity.habitId).update(habitInformation);
    } catch (e) {
      toast("$e");
    }
    await updateDatabaseHabit();
  }
}
