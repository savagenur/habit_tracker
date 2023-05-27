import 'package:habit_tracker/features/domain/entities/user_entity.dart';
import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class CreateUserUsecase {
  final FirebaseRepository repository;

  CreateUserUsecase({required this.repository});
  Future<void> call(UserEntity userEntity)  {
   return repository.createUser(userEntity);
  }
}
