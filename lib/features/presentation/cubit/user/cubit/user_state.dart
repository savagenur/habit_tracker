part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {
  final UserEntity userEntity;
  const UserLoaded({
    required this.userEntity,
  });
  @override
  List<Object> get props => [userEntity];
}

class UserFailure extends UserState {
  @override
  List<Object> get props => [];
}
