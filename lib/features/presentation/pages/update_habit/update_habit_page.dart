import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/features/presentation/bloc/habits/bloc/habits_bloc.dart';
import 'package:habit_tracker/features/presentation/pages/update_habit/widgets/update_habit_main_page.dart';
import 'package:habit_tracker/injection_container.dart' as di;

import '../../../domain/entities/habit/habit_entity.dart';

class UpdateHabitPage extends StatelessWidget {
  final HabitEntity habitEntity;
  final String selectedDay;
  const UpdateHabitPage({super.key, required this.habitEntity, required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<HabitsBloc>(),
      child: UpdateHabitMainPage(habitEntity: habitEntity, selectedDay: selectedDay,),
    );
  }
}