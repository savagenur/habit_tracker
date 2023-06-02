import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class CopyCollectionUsecase {
  final FirebaseRepository repository;
  CopyCollectionUsecase({
    required this.repository,
  });

  Future<void> call(
      {required sourceCollection,
      required destCollection,
      bool isNewDay = false}) async {
    return repository.copyCollection(
        sourceCollection: sourceCollection, destCollection: destCollection,isNewDay: isNewDay);
  }
}
