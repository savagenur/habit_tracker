import 'package:habit_tracker/features/domain/entities/user/user_entity.dart';
import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class SignUpUserUsecase {
  final FirebaseRepository repository;

  SignUpUserUsecase({required this.repository});
  Future<void> call(UserEntity userEntity)  {
   return repository.signUpUser(userEntity);
  }
}
