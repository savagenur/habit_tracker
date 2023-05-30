import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/constants.dart';
import 'package:habit_tracker/features/presentation/pages/credentials/sign_in_page.dart';
import 'package:habit_tracker/features/presentation/pages/edit_profile/edit_profile_page.dart';
import 'package:habit_tracker/on_generate_route.dart';

import '../../cubit/auth/cubit/auth_cubit.dart';
import '../../cubit/user/cubit/user_cubit.dart';

class HomePage extends StatefulWidget {
  final String uid;

  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getUser(uid: widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        if (userState is UserLoaded) {
          final currentUser = userState.userEntity;
          return Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PageConst.editProfilePage,
                      arguments: EditProfilePage(currentUser: currentUser));
                },
                child: Icon(Icons.person),
              ),
              title: GestureDetector(
                onTap: () {
                  BlocProvider.of<AuthCubit>(context).loggedOut();
                },
                child: Text(
                  'Home',
                ),
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
