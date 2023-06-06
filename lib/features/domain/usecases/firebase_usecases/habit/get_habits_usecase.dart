import 'package:habit_tracker/features/domain/entities/habit/habit_entity.dart';
import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class GetHabitsUsecase {
  final FirebaseRepository repository;
  GetHabitsUsecase({
    required this.repository,
  });

  Stream<List<HabitEntity>> call(String uid,String dayString) {
    return repository.getHabits( uid,dayString);
  }
}
