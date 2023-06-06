part of 'habits_bloc.dart';

abstract class HabitsEvent extends Equatable {
  const HabitsEvent();

  @override
  List<Object> get props => [];
}

class CreateHabitEvent extends HabitsEvent {
  final HabitEntity habitEntity;
  const CreateHabitEvent({
    required this.habitEntity,
  });
}
class LoadDataHabitEvent extends HabitsEvent {
  final String uid;
  const LoadDataHabitEvent({
    required this.uid,
  });
}

class UpdateHabitEvent extends HabitsEvent {
  final HabitEntity habitEntity;
  final String day;
  final String habitId;
  final bool isChangedOnlyCheckBool;
  const UpdateHabitEvent({
    required this.habitEntity,
    required this.day,
    required this.habitId,
    required this.isChangedOnlyCheckBool,
  });
}
class DeleteHabitEvent extends HabitsEvent {
  final String habitId;
  const DeleteHabitEvent({
    required this.habitId,
  });
}
class GetHabitsEvent extends HabitsEvent {
  final String uid;
  final String dayString;
  const GetHabitsEvent({
    required this.uid,
    required this.dayString,
  });
}
