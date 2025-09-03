import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_guide_app/common/bloc/lang/locale_state.dart';
import 'package:flutter/material.dart';

class LocaleCubit extends Cubit<LocaleState> {
  static const String _localeKey = "app_locale";

  LocaleCubit() : super(LocaleLoading()) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey);
    if (code != null) {
      emit(LocaleLoaded(Locale(code)));
    } else {
      emit(LocaleLoaded(Locale('en'))); 
    }
  }

  Future<void> setLocale(Locale locale) async {
    emit(LocaleLoading());
    await Future.delayed(const Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    emit(LocaleLoaded(locale));
  }
}
