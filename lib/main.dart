import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vishisht_project/screen/authenication/bloc/authenication_bloc.dart';
import 'package:vishisht_project/screen/authenication/bloc/authenication_event.dart';
import 'package:vishisht_project/screen/authenication/bloc/authenication_state.dart';
import 'package:vishisht_project/screen/authenication/authenication_view.dart';
import 'package:vishisht_project/screen/dashboard/dashboard_view.dart';
import 'package:vishisht_project/screen/theme/theme_bloc.dart';
import 'package:vishisht_project/screen/theme/theme_state.dart';

import 'screen/splash/splash_screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationBloc()..add(CheckSessionEvent())),
        BlocProvider(create: (context) => ThemeBloc()), 
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          title: 'Vishisht',
          debugShowCheckedModeBanner: false,
          theme: themeState.themeData, 
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) =>
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    if (state is Authenticated) {
                      return const DashboardScreen();
                    } else if (state is Unauthenticated) {
                      return const LoginScreen();
                    } else {
                      return const Scaffold(
                          body: Center(child: CircularProgressIndicator()));
                    }
                  },
                ),
            '/dashboard': (context) => const DashboardScreen(),
          },
        );
      },
    );
  }
}
