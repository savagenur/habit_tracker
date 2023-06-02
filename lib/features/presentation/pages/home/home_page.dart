import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/features/presentation/bloc/habits/bloc/habits_bloc.dart';
import 'package:habit_tracker/features/presentation/pages/home/widgets/home_page_main_widget.dart';
import 'package:habit_tracker/injection_container.dart' as di;



class HomePage extends StatelessWidget {
  final String uid;
  const HomePage({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HabitsBloc>(
      create: (_) => di.sl<HabitsBloc>(),
      child: HomePageMainWidget(uid:uid),
    );
  }
}
