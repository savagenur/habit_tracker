import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class ResetPasswordUseCase {
  final FirebaseRepository repository;
  ResetPasswordUseCase({
    required this.repository,
  });
  Future<void> call(String email) async{
    return repository.resetPassword(email);
  }
}
