import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class IsSignInUsecase {
  final FirebaseRepository repository;

  IsSignInUsecase({required this.repository});
  Future<bool> call()  {
   return repository.isSignIn();
  }
}
