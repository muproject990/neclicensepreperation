import 'package:fpdart/fpdart.dart';
import 'package:neclicensepreperation/core/error/exception.dart';
import 'package:neclicensepreperation/core/error/failure.dart';
import 'package:neclicensepreperation/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:neclicensepreperation/features/auth/data/models/user_model.dart';
import 'package:neclicensepreperation/features/auth/domain/auth-repository.dart';
import 'package:neclicensepreperation/core/common/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUserDate();
      if (user == null) {
        return left(Failure("User not logged in!"));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(
          "Error on current User in authRepository Implementataions ${e.message}"));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

// ! signUpWithEmailPassword
  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(() async => await remoteDataSource.signUpWithEmailPassword(
          name: name,
          email: email,
          password: password,
        ));
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      final user = await fn();

      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
