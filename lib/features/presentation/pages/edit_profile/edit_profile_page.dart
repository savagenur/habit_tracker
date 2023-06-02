import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/features/domain/entities/user/user_entity.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:habit_tracker/features/presentation/cubit/auth/cubit/auth_cubit.dart';

import 'package:habit_tracker/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:habit_tracker/features/presentation/widgets/button_container_widget.dart';
import 'package:habit_tracker/features/presentation/widgets/form_container_widget.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants.dart';
import '../../../../profile_widget.dart';
import 'package:habit_tracker/injection_container.dart' as di;

class EditProfilePage extends StatefulWidget {
  final UserEntity currentUser;
  const EditProfilePage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController usernameController;
  @override
  void initState() {
    usernameController =
        TextEditingController(text: widget.currentUser.username);
    super.initState();
  }

  bool _isUpdating = false;

  File? _image;

  Future selectImage() async {
    try {
      final pickedFile =
          await ImagePicker.platform.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occurred $e");
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: 20,
            ),
            child: GestureDetector(
              onTap: () => BlocProvider.of<AuthCubit>(context).loggedOut().then((value) => Navigator.pushNamedAndRemoveUntil(context, PageConst.signInPage, (route) => false)),
              child: Icon(Icons.logout)),
          )
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(
                flex: 1,
              ),
              Container(
                width: 80,
                height: 80,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: profileWidget(
                      widget.currentUser.profileUrl,
                      _image,
                    )),
              ),
              sizeVer(10),
              Center(
                child: GestureDetector(
                  onTap: selectImage,
                  child: Text(
                    "Change profile photo",
                    style: TextStyle(
                      color: blueColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              sizeVer(20),
              FormContainerWidget(
                hintText: "Username",
                controller: usernameController,
              ),
              sizeVer(20),
              ButtonContainerWidget(
                text: "Done",
                onTapListener: _updateUserProfileData,
                color: blueColor,
              ),
              _isUpdating
                  ? Column(
                      children: [
                        sizeVer(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Please wait...",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            sizeHor(5),
                            CircularProgressIndicator(),
                          ],
                        )
                      ],
                    )
                  : Container(),
              Spacer(
                flex: 2,
              ),
            ],
          )),
    );
  }

  _updateUserProfileData() {
    setState(() {
      _isUpdating = true;
    });

    if (_image == null) {
      _updateUserProfile('');
    } else {
      di
          .sl<UploadImageToStorageUsecase>()
          .call(_image!, "profileImages")
          .then((profileUrl) {
        _updateUserProfile(profileUrl);
      });
    }
  }

  _updateUserProfile(String profileUrl) {
    BlocProvider.of<UserCubit>(context)
        .updateUser(
            userEntity: UserEntity(
          uid: widget.currentUser.uid,
          username: usernameController.text,
          profileUrl: profileUrl,
        ))
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _isUpdating = false;
    });
    Navigator.pop(context);
  }
}
