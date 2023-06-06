import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/features/presentation/bloc/habits/bloc/habits_bloc.dart';
import 'package:habit_tracker/features/presentation/pages/create_habit/widgets/create_habit_main_page.dart';
import 'package:habit_tracker/injection_container.dart' as di;
class CreateHabitPage extends StatelessWidget {
  const CreateHabitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<HabitsBloc>(),
      child: const CreateHabitMainHabitPage(),
    );
  }
}
