import 'package:habit_tracker/features/domain/entities/user/user_entity.dart';
import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class GetUserUsecase {
  final FirebaseRepository repository;

  GetUserUsecase({required this.repository});
  Stream<List<UserEntity>> call(String uid)  {
   return repository.getUser(uid);
  }
}
