import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/date_time.dart';
import 'package:habit_tracker/features/presentation/bloc/calendar/bloc/calendar_bloc.dart';
import 'package:habit_tracker/features/presentation/bloc/habits/bloc/habits_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../data/models/habit/habit_model.dart';
import '../../../../domain/entities/habit/habit_entity.dart';

class CalendarWidget extends StatefulWidget {
  final String uid;
  final String startedAt;
  final bool isTouchable;

  final Map habitsDoneMap;
  const CalendarWidget(
      {super.key,
      required this.uid,
      required this.habitsDoneMap,
      required this.startedAt,
      this.isTouchable = true});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _format = CalendarFormat.twoWeeks;

  final Map colorsets = {
    1: Color.fromARGB(10, 2, 179, 8),
    2: Color.fromARGB(30, 2, 179, 8),
    3: Color.fromARGB(50, 2, 179, 8),
    4: Color.fromARGB(70, 2, 179, 8),
    5: Color.fromARGB(90, 2, 179, 8),
    6: Color.fromARGB(110, 2, 179, 8),
    7: Color.fromARGB(140, 2, 179, 8),
    8: Color.fromARGB(160, 2, 179, 8),
    9: Color.fromARGB(200, 2, 179, 8),
    10: Color.fromARGB(225, 2, 179, 8),
  };
  @override
  void initState() {
    super.initState();
  }

  Widget _buildDayWithEvents(DateTime date, List events) {
    final textColor = Colors.white;
    final backgroundColor = colorsets[widget.habitsDoneMap[date]];

    return Container(
      margin: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              date.day.toString(),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          widget.habitsDoneMap[date] == 10
              ? const Positioned(
                  bottom: 0,
                  right: 2,
                  child: Icon(Icons.done_all,size: 20,),
                )
              : Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: createDateTimeObject(widget.startedAt),
      lastDay: DateTime.now(),
      calendarFormat: _format,
      onFormatChanged: (format) {
        setState(() {
          _format = format;
        });
      },
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Colors.blue
        )
      ),
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay) && widget.isTouchable) {
          if (convertDateTimeToString(selectedDay) == todaysDateFormatted()) {
            BlocProvider.of<HabitsBloc>(context).add(
                GetHabitsEvent(uid: widget.uid, dayString: "todaysHabitList"));
          } else {
            BlocProvider.of<HabitsBloc>(context).add(GetHabitsEvent(
                uid: widget.uid,
                dayString: convertDateTimeToString(selectedDay)));
          }
          BlocProvider.of<CalendarBloc>(context).add(SelectDayCalendarEvent(
              dateTime: selectedDay, habitsMap: widget.habitsDoneMap));
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekVisible: true,
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          final dayString = convertDateTimeToString(day);
          day = createDateTimeObject(dayString);
          return _buildDayWithEvents(day, events);
        },
      ),
    );
  }
}
