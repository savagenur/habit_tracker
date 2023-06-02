import 'package:habit_tracker/features/domain/entities/user/user_entity.dart';
import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class UpdateUserUsecase {
  final FirebaseRepository repository;

  UpdateUserUsecase({required this.repository});
  Future<void> call(UserEntity userEntity)  {
   return repository.updateUser(userEntity);
  }
}
