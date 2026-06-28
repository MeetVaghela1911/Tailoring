import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const _key = 'app_locale';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  /// Load saved locale from SharedPreferences (call at startup).
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  /// Persist and apply the new locale.
  Future<void> setLocale(Locale locale) async {
    debugPrint('[LocaleProvider] setLocale called: ${locale.languageCode} (current: ${_locale.languageCode})');
    if (_locale == locale) {
      debugPrint('[LocaleProvider] Same locale, skipping');
      return;
    }
    _locale = locale;
    debugPrint('[LocaleProvider] notifyListeners called');
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
    debugPrint('[LocaleProvider] Locale saved to prefs: ${locale.languageCode}');
  }

  /// Map language display name → locale language code.
  static const Map<String, String> nameToCode = {
    'English': 'en',
    'Hindi': 'hi',
    'Gujarati': 'gu',
    'Marathi': 'mr',
    'Tamil': 'ta',
    'Telugu': 'te',
    'Kannada': 'kn',
    'Bengali': 'bn',
    'Punjabi': 'pa',
    'Urdu': 'ur',
  };

  static const Map<String, String> codeToName = {
    'en': 'English',
    'hi': 'Hindi',
    'gu': 'Gujarati',
    'mr': 'Marathi',
    'ta': 'Tamil',
    'te': 'Telugu',
    'kn': 'Kannada',
    'bn': 'Bengali',
    'pa': 'Punjabi',
    'ur': 'Urdu',
  };
}
