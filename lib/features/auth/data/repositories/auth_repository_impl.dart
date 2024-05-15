import 'package:fpdart/fpdart.dart';
import 'package:neclicensepreperation/core/error/exception.dart';
import 'package:neclicensepreperation/core/error/failure.dart';
import 'package:neclicensepreperation/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:neclicensepreperation/features/auth/data/models/user_model.dart';
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
