import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class UpdateDatabaseHabitUsecase {
  final FirebaseRepository repository;
  UpdateDatabaseHabitUsecase({
    required this.repository,
  });

  Future<void> call() {
    return repository.updateDatabaseHabit();
  }
}
