import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vishisht_project/screen/theme/theme_event.dart';
import 'package:vishisht_project/screen/theme/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: ThemeData.light())) {
    on<ToggleThemeEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      if (state.themeData.brightness == Brightness.light) {
        emit(ThemeState(themeData: ThemeData.dark()));
        await prefs.setBool('isDarkMode', true);
      } else {
        emit(ThemeState(themeData: ThemeData.light()));
        await prefs.setBool('isDarkMode', false);
      }
    });

    _loadThemePreference();
  }

  void _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    emit(ThemeState(themeData: isDarkMode ? ThemeData.dark() : ThemeData.light()));
  }
}
