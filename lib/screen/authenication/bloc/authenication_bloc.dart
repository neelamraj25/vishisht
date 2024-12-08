import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vishisht_project/screen/authenication/bloc/authenication_event.dart';
import 'package:vishisht_project/screen/authenication/bloc/authenication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<CheckSessionEvent>(_onCheckSession);
     on<LogoutEvent>(_onLogout);
  }

Future<void> _onLogin(LoginEvent event, Emitter<AuthenticationState> emit) async {
  emit(Authenticating());

  await Future.delayed(const Duration(seconds: 1));

  if (event.email == "test@example.com" && event.password == "password123") {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', event.email); 
      print('email   ${event.email}');
    emit(Authenticated());
   
  } else {
    emit(AuthError("Invalid email or password. Please try again."));
  }
}


  Future<void> _onCheckSession(CheckSessionEvent event, Emitter<AuthenticationState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

Future<void> _onLogout(LogoutEvent event, Emitter<AuthenticationState> emit) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  print("Logged out and cleared preferences"); 
  emit(Unauthenticated());
}

}
