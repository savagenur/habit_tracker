import 'package:habit_tracker/features/domain/entities/habit/habit_entity.dart';
import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class UpdateHabitUsecase {
  final FirebaseRepository repository;
  UpdateHabitUsecase({
    required this.repository,
  });

  Future<void> call({required HabitEntity habitEntity}) {
    return repository.updateHabit(habitEntity);
  }
}
