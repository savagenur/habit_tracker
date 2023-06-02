import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class GetStartedAtUsecase {
  final FirebaseRepository repository;
  GetStartedAtUsecase({
    required this.repository,
  });

  Future<String?> call() {
    return repository.getStartedAt();
  }
}
