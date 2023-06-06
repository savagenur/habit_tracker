import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habit_tracker/date_time.dart';
import 'package:habit_tracker/features/data/models/habit/habit_model.dart';
import 'package:habit_tracker/features/domain/entities/habit/habit_entity.dart';
import 'package:habit_tracker/features/presentation/bloc/calendar/bloc/calendar_bloc.dart';
import 'package:habit_tracker/features/presentation/pages/edit_profile/edit_profile_page.dart';
import 'package:habit_tracker/features/presentation/pages/home/widgets/calendar_widget.dart';
import 'package:habit_tracker/features/presentation/pages/home/widgets/habit_tile.dart';
import 'package:habit_tracker/features/presentation/pages/update_habit/update_habit_page.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../constants.dart';
import '../../../bloc/habits/bloc/habits_bloc.dart';
import '../../../cubit/auth/cubit/auth_cubit.dart';
import '../../../cubit/user/cubit/user_cubit.dart';
import 'package:habit_tracker/injection_container.dart' as di;

class HomePageMainWidget extends StatefulWidget {
  final String uid;

  const HomePageMainWidget({super.key, required this.uid});

  @override
  State<HomePageMainWidget> createState() => _HomePageMainWidgetState();
}

class _HomePageMainWidgetState extends State<HomePageMainWidget> {
  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getUser(uid: widget.uid);

    BlocProvider.of<CalendarBloc>(context)
        .add(GetCalendarDoneMapEvent(uid: widget.uid));

    super.initState();
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
              actions: [
                GestureDetector(
                  onTap: () {
                    // getMapForCalendar();
                  },
                  child: Icon(Icons.edit),
                )
              ],
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
                      BlocBuilder<CalendarBloc, CalendarState>(
                        builder: (context, calendarState) {
                          if (calendarState is CalendarLoaded) {
                            return BlocProvider.value(
                              value: BlocProvider.of<HabitsBloc>(context),
                              child: CalendarWidget(
                                uid: widget.uid,
                                habitsDoneMap: calendarState.habitsMap,
                                startedAt: habitsState.startedAt,
                              ),
                            );
                          }
                          return CalendarWidget(
                            uid: widget.uid,
                            habitsDoneMap: const {},
                            startedAt: habitsState.startedAt,
                            isTouchable: false,
                          );
                        },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: habitsState.habits.length,
                        itemBuilder: (BuildContext context, int index) {
                          return BlocBuilder<CalendarBloc, CalendarState>(
                            builder: (context, calendarState) {
                              if (calendarState is CalendarLoaded) {
                                return HabitTile(
                                  habitName: habitsState.habits[index].title!,
                                  habitCompleted:
                                      habitsState.habits[index].isCompleted!,
                                  onChanged: (value) {
                                    var habit = habitsState.habits[index];
                                    var updatedHabit =
                                        habit.copyWith(isCompleted: value);
                                    BlocProvider.of<HabitsBloc>(context).add(
                                        UpdateHabitEvent(
                                            habitEntity: updatedHabit,
                                            day: calendarState.selectedDay));
                                  },
                                  deleteTapped: (context) {
                                    BlocProvider.of<HabitsBloc>(context).add(
                                        DeleteHabitEvent(
                                            habitId: habitsState
                                                .habits[index].habitId!));
                                  },
                                  settingsTapped: (context) {
                                    Navigator.pushNamed(
                                        context, PageConst.updateHabitPage,
                                        arguments: UpdateHabitPage(
                                          habitEntity:
                                              habitsState.habits[index],
                                          selectedDay:
                                              calendarState.selectedDay,
                                        ));
                                  },
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: LottieBuilder.asset(
                                        "assets/skeleton.json",
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const Positioned(
                                        right: 24,
                                        child: Icon(
                                          Icons
                                              .keyboard_double_arrow_left_rounded,
                                          size: 30,
                                        ))
                                  ],
                                ),
                              );
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
