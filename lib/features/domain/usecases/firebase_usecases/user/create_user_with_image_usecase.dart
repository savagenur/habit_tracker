import 'package:habit_tracker/features/domain/entities/user_entity.dart';
import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class CreateUserWithImageUseCase {
  final FirebaseRepository repository;
  CreateUserWithImageUseCase({
    required this.repository,
  });

  Future<void> call(UserEntity userEntity, String profileUrl) async {
    return repository.createUserWithImage(userEntity, profileUrl);
  }
}
