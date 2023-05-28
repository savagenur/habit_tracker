import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import '../../../../domain/usecases/firebase_usecases/user/is_sign_in_usecase.dart';
import '../../../../domain/usecases/firebase_usecases/user/sign_out_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignOutUsecase signOutUsecase;
  final IsSignInUsecase isSignInUsecase;
  final GetCurrentUidUsecase getCurrentUidUsecase;
  AuthCubit({
    required this.signOutUsecase,
    required this.isSignInUsecase,
    required this.getCurrentUidUsecase,
  }) : super(AuthInitial());

  Future<void> appStarted(BuildContext context) async {
    try {
      bool isSignIn = await isSignInUsecase.call();
      if (isSignIn) {
        final uid = await getCurrentUidUsecase.call();
        emit(Authenticated(uid: uid));
      } else {
        emit(UnAuthenticated());
      }
    } catch (_) {}
  }

  Future<void> loggedIn() async {
    try {
      final uid = await getCurrentUidUsecase.call();
      emit(Authenticated(uid: uid));
    } catch (_) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut() async {
    try {
      await signOutUsecase.call();
      emit(UnAuthenticated());
    } catch (_) {
      emit(UnAuthenticated());
    }
  }
}
