import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class SignOutUsecase {
  final FirebaseRepository repository;

  SignOutUsecase({required this.repository});
  Future<void> call()  {
   return repository.signOut();
  }
}
