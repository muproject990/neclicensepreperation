import 'package:fpdart/fpdart.dart';
import 'package:neclicensepreperation/core/error/failure.dart';
import 'package:neclicensepreperation/core/usecase/usercase.dart';
import 'package:neclicensepreperation/features/auth/domain/auth-repository.dart';

class UserSignUp implements UseCase<String, UserSignUpParams> {
  final AuthRepository authRepository;
  
  const UserSignUp( this.authRepository);

  @override
  Future<Either<Failure, String>> call(UserSignUpParams params) async {
    // dont forget to use await becoz sometimes it will takes some time
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;

  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
