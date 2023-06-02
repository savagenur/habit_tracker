import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:habit_tracker/features/domain/entities/habit/habit_entity.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/habit/create_habit_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/habit/delete_habit_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/habit/get_habits_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/habit/get_started_at_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/habit/load_data_habit_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/habit/update_habit_usecase.dart';

part 'habits_event.dart';
part 'habits_state.dart';

class HabitsBloc extends Bloc<HabitsEvent, HabitsState> {
  final LoadDataHabitUsecase loadDataHabitUsecase;
  final GetHabitsUsecase getHabitsUsecase;
  final CreateHabitUsecase createHabitUsecase;
  final DeleteHabitUsecase deleteHabitUsecase;
  final UpdateHabitUsecase updateHabitUsecase;
  final GetStartedAtUsecase getStartedAtUsecase;
  HabitsBloc({
    required this.loadDataHabitUsecase,
    required this.getHabitsUsecase,
    required this.createHabitUsecase,
    required this.deleteHabitUsecase,
    required this.updateHabitUsecase,
    required this.getStartedAtUsecase,
  }) : super(HabitsInitial()) {
    on<LoadDataHabitEvent>(_onLoadDataHabitEvent);
    on<GetHabitsEvent>(_onGetHabitsEvent);
    on<CreateHabitEvent>(_onCreateHabitEvent);
    on<DeleteHabitEvent>(_onDeleteHabitEvent);
    on<UpdateHabitEvent>(_onUpdateHabitEvent);
  }

  Future<void> _onLoadDataHabitEvent(
      LoadDataHabitEvent event, Emitter<HabitsState> emit) async {
    emit(HabitsLoading());
    try {
      await loadDataHabitUsecase.call();
      final startedAt = await getStartedAtUsecase.call();
      try {
        final streamResponse = getHabitsUsecase.call(event.uid);

        await for (var habits in streamResponse) {
          emit(HabitsLoaded(habits: habits,startedAt: startedAt!));
        }
      } on SocketException catch (_) {
        print("Check internet connection!");
        emit(HabitsFailure());
      } catch (e) {
        print("$e");
        emit(HabitsFailure());
      }
    } catch (e) {
      emit(HabitsFailure());
    }
  }

  Future<void> _onGetHabitsEvent(
      GetHabitsEvent event, Emitter<HabitsState> emit) async {
    emit(HabitsLoading());

    try {
      final streamResponse = getHabitsUsecase.call(event.uid);
      streamResponse.listen((habits) {
        try {
          if (habits.isEmpty) {
            emit(const HabitsLoaded(habits: [],startedAt: ""));
          } else {
            emit(HabitsLoaded(habits: habits,startedAt: ""));
          }
        } catch (_) {}
      });
    } on SocketException catch (_) {
      print("Check internet connection!");
      emit(HabitsFailure());
    } catch (e) {
      print("$e");
      emit(HabitsFailure());
    }
  }

  Future<void> _onCreateHabitEvent(
      CreateHabitEvent event, Emitter<HabitsState> emit) async {
    try {
      await createHabitUsecase.call(habitEntity: event.habitEntity);
    } catch (e) {
      emit(HabitsFailure());
    }
  }

  Future<void> _onDeleteHabitEvent(
      DeleteHabitEvent event, Emitter<HabitsState> emit) async {
    try {
      await deleteHabitUsecase.call(habitId: event.habitId);
    } catch (e) {
      emit(HabitsFailure());
    }
  }

  Future<void> _onUpdateHabitEvent(
      UpdateHabitEvent event, Emitter<HabitsState> emit) async {
    try {
      await updateHabitUsecase.call(habitEntity: event.habitEntity);
    } catch (e) {
      emit(HabitsFailure());
    }
  }
}
