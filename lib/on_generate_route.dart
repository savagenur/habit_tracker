import 'package:flutter/material.dart';
import 'package:habit_tracker/constants.dart';
import 'package:habit_tracker/features/presentation/pages/create_habit/create_habit_page.dart';
import 'package:habit_tracker/features/presentation/pages/credentials/forgot_password_page.dart';
import 'package:habit_tracker/features/presentation/pages/credentials/sign_in_page.dart';
import 'package:habit_tracker/features/presentation/pages/credentials/sign_up_page.dart';
import 'package:habit_tracker/features/presentation/pages/edit_profile/edit_profile_page.dart';

import 'features/presentation/pages/home/home_page.dart';
import 'features/presentation/pages/update_habit/update_habit_page.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    dynamic args = settings.arguments;
    switch (settings.name) {
      case PageConst.signInPage:
        return routBuilder(const SignInPage());
      case PageConst.signUpPage:
        return routBuilder(const SignUpPage());
      case PageConst.forgotPasswordPage:
        return routBuilder(const ForgotPasswordPage());
      case PageConst.homePage:
        args as HomePage;
        return routBuilder(HomePage(
          uid: args.uid,
        ));
      case PageConst.editProfilePage:
        args as EditProfilePage;
        return routBuilder(EditProfilePage(
          currentUser: args.currentUser,
        ));
      case PageConst.createHabitPage:
        return routBuilder(const CreateHabitPage());
      case PageConst.updateHabitPage:
        args as UpdateHabitPage;
        return routBuilder(UpdateHabitPage(habitEntity: args.habitEntity, selectedDay: args.selectedDay, uid: args.uid,));
      default:
        return routBuilder(const NoPageFound());
    }
  }
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("No Page Found"),
      ),
      body: const Center(
        child: Text("No Page Found"),
      ),
    );
  }
}

Route routBuilder(Widget child) {
  return MaterialPageRoute(
    builder: (context) => child,
  );
}
