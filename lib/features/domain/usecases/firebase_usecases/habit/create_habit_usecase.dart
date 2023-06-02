import 'package:habit_tracker/features/domain/entities/habit/habit_entity.dart';
import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class CreateHabitUsecase {
  final FirebaseRepository repository;
  CreateHabitUsecase({
    required this.repository,
  });

  Future<void> call({required HabitEntity habitEntity}) {
    return repository.createHabit(habitEntity: habitEntity);
  }
}
