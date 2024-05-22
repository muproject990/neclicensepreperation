import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neclicensepreperation/core/usecase/usercase.dart';
import 'package:neclicensepreperation/features/auth/domain/entities/user.dart';
import 'package:neclicensepreperation/features/auth/domain/usecases/current_user.dart';
import 'package:neclicensepreperation/features/auth/domain/usecases/user_login.dart';
import 'package:neclicensepreperation/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  AuthBloc({
    required UserLogin userLogin,
    required UserSignUp userSignUp,
    required CurrentUser currentUser,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSighUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());
    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) {
        print(" Hello ur id is:  ${r.id}");
        print(" Hello ur email id is:  ${r.email}");

        emit(AuthSuccess(user: r));
      },
    );
  }

  void _onAuthSighUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final response = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );
    print("here");
    // print(response);

    response.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(AuthSuccess(user: r)),
    );
  }

  void _onAuthLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final res = await _userLogin(UserLoginParams(
      email: event.email,
      password: event.password,
    ));

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => emit(AuthSuccess(user: r)),
    );
  }
}
