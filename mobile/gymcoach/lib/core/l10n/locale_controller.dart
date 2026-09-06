import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeKey = 'gymcoach_locale';

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>((ref) => LocaleController());

class LocaleController extends StateNotifier<Locale> {
  LocaleController() : super(const Locale('en')) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey);
    if (code == 'ar' || code == 'en') {
      state = Locale(code!);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Future<void> toggle() async {
    await setLocale(state.languageCode == 'ar' ? const Locale('en') : const Locale('ar'));
  }
}
