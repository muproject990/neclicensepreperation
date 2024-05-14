import 'package:fpdart/fpdart.dart';
import 'package:neclicensepreperation/core/error/exception.dart';
import 'package:neclicensepreperation/core/error/failure.dart';
import 'package:neclicensepreperation/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:neclicensepreperation/features/auth/domain/auth-repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> loginWithEmailPassword(
      {required String email, required String password}) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

// ! signUpWithEmailPassword
  @override
  Future<Either<Failure, String>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userId = await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      print(userId);
      return right(userId);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
