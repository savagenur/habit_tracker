import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class DeleteHabitUsecase {
  final FirebaseRepository repository;
  DeleteHabitUsecase({
    required this.repository,
  });

  Future<void> call({required String habitId}) {
    return repository.deleteHabit(habitId);
  }
}
