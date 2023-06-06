part of 'calendar_bloc.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class GetCalendarDoneMapEvent extends CalendarEvent {
  final String uid;

  const GetCalendarDoneMapEvent({
    required this.uid,
  });
  @override
  List<Object> get props => [];
}
class SelectDayCalendarEvent extends CalendarEvent {
  final Map habitsMap;
  final DateTime dateTime;

  const SelectDayCalendarEvent({
    required this.dateTime,
    required this.habitsMap,
  });
  @override
  List<Object> get props => [];
}
