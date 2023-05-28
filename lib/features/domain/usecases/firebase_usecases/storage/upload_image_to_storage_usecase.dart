import 'dart:io';

import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';

class UploadImageToStorageUsecase {
  final FirebaseRepository repository;
  UploadImageToStorageUsecase({
    required this.repository,
  });

  Future<String> call(File file, String childName) async {
    return repository.uploadImageToStorage(file, childName);
  }
}
