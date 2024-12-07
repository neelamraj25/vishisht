abstract class AuthenticationEvent {}

class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class LogoutEvent extends AuthenticationEvent {} 

class CheckSessionEvent extends AuthenticationEvent {}
