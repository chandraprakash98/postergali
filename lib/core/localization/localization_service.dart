import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_translations.dart';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  final ValueNotifier<String> localeNotifier = ValueNotifier<String>('en');

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('language_code') ?? 'en';
    localeNotifier.value = savedLocale;
  }

  Future<void> changeLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    localeNotifier.value = languageCode;
  }

  String translate(String key) {
    return AppTranslations.translate(key, localeNotifier.value);
  }

  bool get isHindi => localeNotifier.value == 'hi';
}

// Extension for easy access in widgets
extension LocalizationExtension on BuildContext {
  String tr(String key) {
    return LocalizationService().translate(key);
  }
}
