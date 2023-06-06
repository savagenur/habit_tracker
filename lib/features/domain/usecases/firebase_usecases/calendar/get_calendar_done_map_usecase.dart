import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class GetCalendarDoneMapUsecase {
  final FirebaseRepository repository;
  GetCalendarDoneMapUsecase({
    required this.repository,
  });

  Future<Map> call(String uid) async {
    return repository.getCalendarDoneMap(uid);
  }
}
