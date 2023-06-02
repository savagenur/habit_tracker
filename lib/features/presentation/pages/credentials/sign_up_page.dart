import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/profile_widget.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../cubit/auth/cubit/auth_cubit.dart';
import '../../cubit/credential/cubit/credential_cubit.dart';
import '../../widgets/button_container_widget.dart';
import '../../widgets/form_container_widget.dart';
import '../home/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool _isSigningUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _userNameController.dispose();
    _bioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  File? _image;

  Future selectImage() async {
    try {
      final pickedFile =
          // ignore: invalid_use_of_visible_for_testing_member
          await ImagePicker.platform.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("No image has been selected");
        }
      });
    } catch (e) {
      toast("Some error occurred $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredentialCubit, CredentialState>(
      listener: (context, credentialState) {
        if (credentialState is CredentialSuccess) {
          BlocProvider.of<AuthCubit>(context).loggedIn();
        }
        if (credentialState is CredentialFailure) {
          toast("Invalid Email or Password!");
        }
      },
      builder: (context, credentialState) {
        if (credentialState is CredentialSuccess) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return HomePage(uid: authState.uid,);
              } else {
                return _bodyWidget();
              }
            },
          );
        }
        return _bodyWidget();
      },
    );
  }

  Future<void> _signUpUser() async {
    setState(() {
      _isSigningUp = true;
    });
    BlocProvider.of<CredentialCubit>(context)
        .signUpUser(
            userEntity: UserEntity(
          email: _emailController.text,
          username: _userNameController.text,
          password: _passwordController.text,
          name: "",
          profileUrl: "",
          totalHabits: 0,
          imageFile: _image,
        ))
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _emailController.clear();
      _userNameController.clear();
      _bioController.clear();
      _passwordController.clear();
      _isSigningUp = false;
    });
  }

  _bodyWidget() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            const Center(
              child: Text(
                "Habit Tracker",
                style: TextStyle(color: primaryColor, fontSize: 23),
              ),
            ),
            sizeVer(20),
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: secondaryColor,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: profileWidget("", _image),
                    ),
                  ),
                  Positioned(
                      right: -5,
                      bottom: -5,
                      child: GestureDetector(
                        onTap: selectImage,
                        child: const Icon(
                          Icons.photo_camera_rounded,
                          color: blueColor,
                        ),
                      ))
                ],
              ),
            ),
            sizeVer(20),
            FormContainerWidget(
              controller: _userNameController,
              hintText: "Username",
            ),
            sizeVer(15),
            FormContainerWidget(
              controller: _emailController,
              hintText: "Email",
            ),
            sizeVer(15),
            FormContainerWidget(
              controller: _passwordController,
              hintText: "Password",
              isPasswordField: true,
            ),
            sizeVer(15),
            ButtonContainerWidget(
              color: blueColor,
              text: "Sign Up",
              onTapListener: _signUpUser,
            ),
            _isSigningUp ? sizeVer(10) : Container(),
            _isSigningUp
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Please wait...",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      sizeHor(5),
                      const CircularProgressIndicator(),
                    ],
                  )
                : Container(),
            Flexible(
              flex: 2,
              child: Container(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  _bottomNavigationBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(
          color: secondaryColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Already have an account? ",
              style: TextStyle(
                color: primaryColor,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, PageConst.signInPage, (route) => false);
              },
              child: const Text(
                "Sign In.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
        sizeVer(10)
      ],
    );
  }
}
