abstract class AuthenticationState {}

class AuthInitial extends AuthenticationState {}

class Authenticating extends AuthenticationState {}

class Authenticated extends AuthenticationState {}

class Unauthenticated extends AuthenticationState {}

class AuthError extends AuthenticationState {
  final String message;

  AuthError(this.message);
}
