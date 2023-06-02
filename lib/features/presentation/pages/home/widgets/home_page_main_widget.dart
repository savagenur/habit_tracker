import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/date_time.dart';
import 'package:habit_tracker/features/presentation/pages/edit_profile/edit_profile_page.dart';
import 'package:habit_tracker/features/presentation/pages/home/widgets/habit_tile.dart';
import 'package:habit_tracker/features/presentation/pages/update_habit/update_habit_page.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../constants.dart';
import '../../../bloc/habits/bloc/habits_bloc.dart';
import '../../../cubit/auth/cubit/auth_cubit.dart';
import '../../../cubit/user/cubit/user_cubit.dart';

class HomePageMainWidget extends StatefulWidget {
  final String uid;

  const HomePageMainWidget({super.key, required this.uid});

  @override
  State<HomePageMainWidget> createState() => _HomePageMainWidgetState();
}

class _HomePageMainWidgetState extends State<HomePageMainWidget> {
  String startedAt = "";
  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getUser(uid: widget.uid);
    BlocProvider.of<HabitsBloc>(context)
        .add(LoadDataHabitEvent(uid: widget.uid));
    super.initState();
  }

  bool checked = false;
  void checkBoxTapped(bool? value) {
    setState(() {
      checked = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        if (userState is UserLoaded) {
          final currentUser = userState.userEntity;
          return Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PageConst.editProfilePage,
                      arguments: EditProfilePage(currentUser: currentUser));
                },
                child: const Icon(Icons.person),
              ),
              title: GestureDetector(
                onTap: () {
                  BlocProvider.of<AuthCubit>(context).loggedOut();
                },
                child: const Text(
                  'Home',
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, PageConst.createHabitPage);
              },
              child: const Icon(Icons.add),
            ),
            body: BlocBuilder<HabitsBloc, HabitsState>(
              builder: (context, habitsState) {
                if (habitsState is HabitsLoaded) {
                  return ListView(
                    children: [
                      TableCalendar(
                        focusedDay: DateTime.now(),
                        firstDay: createDateTimeObject(habitsState.startedAt),
                        lastDay: DateTime.now(),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: habitsState.habits.length,
                        itemBuilder: (BuildContext context, int index) {
                          return HabitTile(
                            habitName: habitsState.habits[index].title!,
                            habitCompleted:
                                habitsState.habits[index].isCompleted!,
                            onChanged: (value) {
                              var habit = habitsState.habits[index];
                              var updatedHabit =
                                  habit.copyWith(isCompleted: value);
                              BlocProvider.of<HabitsBloc>(context).add(
                                  UpdateHabitEvent(habitEntity: updatedHabit));
                            },
                            deleteTapped: (context) {
                              BlocProvider.of<HabitsBloc>(context).add(
                                  DeleteHabitEvent(
                                      habitId:
                                          habitsState.habits[index].habitId!));
                            },
                            settingsTapped: (context) {
                              Navigator.pushNamed(
                                  context, PageConst.updateHabitPage,
                                  arguments: UpdateHabitPage(
                                      habitEntity: habitsState.habits[index]));
                            },
                          );
                        },
                      ),
                    ],
                  );
                }
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  
}
