import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants.dart';
import '../../cubit/auth/cubit/auth_cubit.dart';
import '../../cubit/credential/cubit/credential_cubit.dart';
import '../../widgets/button_container_widget.dart';
import '../../widgets/form_container_widget.dart';
import '../home/home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSigningIn = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              "Don't have an account? ",
              style: TextStyle(
                color: primaryColor,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, PageConst.signUpPage, (route) => false);
              },
              child: const Text(
                "Sign Up.",
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

  void _signIn() {
    setState(() {
      _isSigningIn = true;
    });
    BlocProvider.of<CredentialCubit>(context)
        .signInUser(
            email: _emailController.text, password: _passwordController.text)
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _isSigningIn = false;
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
            sizeVer(30),
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
              text: "Sign In",
              onTapListener: _signIn,
            ),
                      sizeVer(15),

            GestureDetector(
              onTap: () => Navigator.pushNamed(context, PageConst.forgotPasswordPage),
              child: const Text(
                "Forgot Password?",
                style: TextStyle(
                  color: blueColor,
                ),
              ),
            ),
            _isSigningIn
                ? Column(
                    children: [
                      sizeVer(10),
                      Row(
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
}
