import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  static const _key = 'isDarkMode';

  ThemeCubit() : super(false) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final pref = await SharedPreferences.getInstance();
    final isDark = pref.getBool(_key) ?? false;
    emit(isDark);
  }

  Future<void> toggle() async {
    final newState = !state;
    emit(newState);
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_key, newState);
  }
}
