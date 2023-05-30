import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:habit_tracker/features/domain/entities/user_entity.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/user/reset_password_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/user/sign_in_user_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/user/sign_up_user_usecase.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignInUserUsecase signInUserUsecase;
  final SignUpUserUsecase signUpUserUsecase;
  final ResetPasswordUseCase resetPasswordUseCase;
  CredentialCubit({
    required this.signInUserUsecase,
    required this.signUpUserUsecase,
    required this.resetPasswordUseCase,
  }) : super(CredentialInitial());

  Future<void> signInUser({String? email, required String password}) async {
    emit(CredentialLoading());
    try {
      await signInUserUsecase.call(UserEntity(
        email: email,
        password: password,
      ));
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> signUpUser({required UserEntity userEntity}) async {
    emit(CredentialLoading());
    try {
      await signUpUserUsecase.call(userEntity);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> resetPasswordUser({required String email}) async {
    emit(CredentialLoading());
    try {
      await resetPasswordUseCase.call(email);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }
}
