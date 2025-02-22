part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {
  get user => null;
}

final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  @override
  final User user;
  AppUserLoggedIn(this.user);
}
