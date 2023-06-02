import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class LoadDataHabitUsecase {
  final FirebaseRepository repository;
  LoadDataHabitUsecase({
    required this.repository,
  });

  Future<void> call() {
    return repository.loadDataHabit();
  }
}
