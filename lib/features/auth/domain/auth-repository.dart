import 'package:fpdart/fpdart.dart';
import 'package:neclicensepreperation/core/error/failure.dart';
import 'package:neclicensepreperation/features/auth/data/models/user_model.dart';
import 'package:neclicensepreperation/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();

}
