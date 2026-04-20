import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void changeTheme(String theme) {
    if (theme == 'dark') {
      emit(ThemeMode.dark);
    } else if (theme == 'light') {
      emit(ThemeMode.light);
    }
  }

  bool get isDark => state == ThemeMode.dark;
}