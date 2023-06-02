import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:habit_tracker/features/domain/entities/user/user_entity.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/user/get_user_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/user/update_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUserUsecase getUserUsecase;
  final UpdateUserUsecase updateUserUseCase;
  UserCubit({
    required this.getUserUsecase,
    required this.updateUserUseCase,
  }) : super(UserInitial());

  Future<void> getUser({required String uid}) async {
    emit(UserLoading());
    try {
      final streamResponse = getUserUsecase.call(uid);
      streamResponse.listen((users) {
        try {
          emit(UserLoaded(userEntity: users.first));
        } catch (_) {}
      });
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> updateUser({required UserEntity userEntity}) async {
    try {
      await updateUserUseCase.call(userEntity);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }
}
