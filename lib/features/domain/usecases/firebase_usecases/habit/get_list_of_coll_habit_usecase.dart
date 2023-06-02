import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class GetListOfCollHabitUsecase {
  final FirebaseRepository repository;
  GetListOfCollHabitUsecase({
    required this.repository,
  });

  Future<List> call() {
    return repository.getListOfCollHabit();
  }
}
