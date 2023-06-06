part of 'calendar_bloc.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarInitial extends CalendarState {
  @override
  List<Object> get props => [];
}

class CalendarLoading extends CalendarState {
  @override
  List<Object> get props => [];
}

class CalendarLoaded extends CalendarState {
  final Map habitsMap;
  final String selectedDay;
  const CalendarLoaded({
    required this.habitsMap,
    required this.selectedDay,
  });
  @override
  List<Object> get props => [
        habitsMap,
        selectedDay,
      ];
}

class CalendarFailure extends CalendarState {
  @override
  List<Object> get props => [];
}
