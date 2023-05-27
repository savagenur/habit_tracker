import 'package:habit_tracker/features/domain/entities/user_entity.dart';
import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class GetCurrentUidUsecase {
  final FirebaseRepository repository;

  GetCurrentUidUsecase({required this.repository});
  Future<String> call()  {
   return repository.getCurrentUid();
  }
}
