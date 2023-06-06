import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:habit_tracker/constants.dart';
import 'package:habit_tracker/date_time.dart';

import 'package:habit_tracker/features/domain/usecases/firebase_usecases/calendar/get_calendar_done_map_usecase.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final GetCalendarDoneMapUsecase getCalendarDoneMapUsecase;
  CalendarBloc({
    required this.getCalendarDoneMapUsecase,
  }) : super(CalendarInitial()) {
    on<GetCalendarDoneMapEvent>(_onGetCalendarDoneMapEvent);
    on<SelectDayCalendarEvent>(_onSelectDayCalendarEvent);
  }
  Future<void> _onGetCalendarDoneMapEvent(
      GetCalendarDoneMapEvent event, Emitter<CalendarState> emit) async {
    emit(CalendarLoading());
    try {
      final habitsMap = await getCalendarDoneMapUsecase.call(event.uid);
      emit(CalendarLoaded(
          habitsMap: habitsMap, selectedDay: todaysDateFormatted()));
    } catch (e) {
      emit(CalendarFailure());
      toast(e.toString());
    }
  }

  _onSelectDayCalendarEvent(
      SelectDayCalendarEvent event, Emitter<CalendarState> emit) {
    var selectedDay = convertDateTimeToString(event.dateTime);
    emit(CalendarLoaded(habitsMap: event.habitsMap, selectedDay: selectedDay));
  }
}
