import 'package:fpdart/fpdart.dart';
import 'package:neclicensepreperation/core/error/exception.dart';
import 'package:neclicensepreperation/core/error/failure.dart';
import 'package:neclicensepreperation/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:neclicensepreperation/features/auth/data/models/user_model.dart';
import 'package:neclicensepreperation/features/auth/domain/auth-repository.dart';
import 'package:neclicensepreperation/features/auth/domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserModel>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      );
      return right(user as UserModel);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

// ! signUpWithEmailPassword
  @override
  Future<Either<Failure, UserModel>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      // print(userId);
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }



}
