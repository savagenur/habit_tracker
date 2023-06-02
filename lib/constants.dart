import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const backgroundColor = Color.fromRGBO(0, 0, 0, 1.0);
const blueColor = Color.fromRGBO(0, 149, 246, 1.0);
const primaryColor = Colors.white;
const secondaryColor = Colors.grey;
const darkGreyColor = Color.fromRGBO(97, 97, 97, 1.0);

Widget sizeVer(double height) {
  return SizedBox(
    height: height,
  );
}

Widget sizeHor(double width) {
  return SizedBox(
    width: width,
  );
}

class PageConst {
  static const String editProfilePage = "editProfilePage";
  static const String homePage = "homePage";
  static const String forgotPasswordPage = "forgotPasswordPage";
  static const String createHabitPage = "createHabitPage";
  static const String updateHabitPage = "updateHabitPage";
  static const String signInPage = "signInPage";
  static const String signUpPage = "signUpPage";
}

class FirebaseConst {
  static const String users = "users";
  static const String habits = "habits";
  static const String habitList = "habitList";
  static const String currentHabitList = "currentHabitList";
  static const String todaysHabitList = "todaysHabitList";
}

void toast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: blueColor,
    textColor: Colors.white,
    fontSize: 16,
  );
}