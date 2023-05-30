import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_tracker/features/data/datasources/remote_data_source/remote_data_source.dart';
import 'package:habit_tracker/features/data/datasources/remote_data_source/remote_data_source_impl.dart';
import 'package:habit_tracker/features/data/repositories/firebase_repository_impl.dart';
import 'package:habit_tracker/features/domain/repositories/firebase_repository.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/user/create_user_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/user/create_user_with_image_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/user/get_user_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/user/is_sign_in_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/user/reset_password_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/user/sign_in_user_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/user/sign_out_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/user/sign_up_user_usecase.dart';
import 'package:habit_tracker/features/domain/usecases/firebase_usecases/user/update_user_usecase.dart';
import 'package:habit_tracker/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:habit_tracker/features/presentation/cubit/credential/cubit/credential_cubit.dart';
import 'package:habit_tracker/features/presentation/cubit/user/cubit/user_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Cubits

  sl.registerFactory(() => AuthCubit(
      signOutUsecase: sl.call(),
      isSignInUsecase: sl.call(),
      getCurrentUidUsecase: sl.call()));

  sl.registerFactory(() => CredentialCubit(
      signInUserUsecase: sl.call(), signUpUserUsecase: sl.call(), resetPasswordUseCase: sl.call()));
  sl.registerFactory(
      () => UserCubit(getUserUsecase: sl.call(), updateUserUseCase: sl.call()));

  // UseCases

  sl.registerLazySingleton(() => SignOutUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => IsSignInUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetCurrentUidUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => SignInUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => SignUpUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(repository: sl.call()));
  sl.registerLazySingleton(
      () => CreateUserWithImageUseCase(repository: sl.call()));

  // Cloud Storage usecase
  sl.registerLazySingleton(
      () => UploadImageToStorageUsecase(repository: sl.call()));

  // Repository
  sl.registerLazySingleton<FirebaseRepository>(
      () => FirebaseRepositoryImpl(remoteDataSource: sl.call()));

  // RemoteDataSource
  sl.registerLazySingleton<FirebaseRemoteDataSource>(() =>
      FirebaseRemoteDataSourceImpl(
          firebaseAuth: sl.call(),
          firebaseFirestore: sl.call(),
          firebaseStorage: sl.call()));

  // Externals

  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;

  sl.registerLazySingleton(() => firebaseAuth);
  sl.registerLazySingleton(() => firebaseFirestore);
  sl.registerLazySingleton(() => firebaseStorage);
}
