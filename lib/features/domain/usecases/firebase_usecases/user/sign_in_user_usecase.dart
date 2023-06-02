import 'package:habit_tracker/features/domain/entities/user/user_entity.dart';
import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class SignInUserUsecase {
  final FirebaseRepository repository;

  SignInUserUsecase({required this.repository});
  Future<void> call(UserEntity userEntity)  {
   return repository.signInUser(userEntity);
  }
}
