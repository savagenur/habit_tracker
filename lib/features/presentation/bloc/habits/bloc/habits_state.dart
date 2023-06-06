part of 'habits_bloc.dart';

abstract class HabitsState extends Equatable {
  const HabitsState();

  @override
  List<Object> get props => [];
}

class HabitsInitial extends HabitsState {
  @override
  List<Object> get props => [];
}

class HabitsLoaded extends HabitsState {
  final List<HabitEntity> habits;
  final String startedAt;
  const HabitsLoaded({
    required this.habits,
    required this.startedAt,
  });
  @override
  List<Object> get props => [
        habits,
        startedAt,
      ];
}

class HabitsLoading extends HabitsState {
  @override
  List<Object> get props => [];
}
class ChosenHabitsLoading extends HabitsState {
  @override
  List<Object> get props => [];
}

class HabitsFailure extends HabitsState {
  @override
  List<Object> get props => [];
}
