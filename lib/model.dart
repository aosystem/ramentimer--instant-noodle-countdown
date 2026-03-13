import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ramentimer/l10n/app_localizations.dart';
import 'package:ramentimer/const_value.dart';

class Model {
  Model._();

  static const String _prefStartTime = "startTime";
  static const String _prefCupImage = "cupImage";
  static const String _prefWakelockEnabled = 'wakelockEnabled';
  static const String _prefSoundEnabled = 'soundEnabled';
  static const String _prefSoundVolume = 'soundVolume';
  static const String _prefSoundSelect = 'soundSelect';
  static const String _prefVibrateEnabled = 'vibrateEnabled';
  static const String _prefSchemeColor = 'schemeColor';
  static const String _prefThemeNumber = "themeNumber";
  static const String _prefLanguageCode = "languageCode";

  static bool _ready = false;
  static int _startTime = 3;
  static int _cupImage = 1;
  static bool _wakelockEnabled = true;
  static bool _soundEnabled = true;
  static double _soundVolume = 1.0;
  static int _soundSelect = 0;
  static bool _vibrateEnabled = true;
  static int _schemeColor = 40;
  static int _themeNumber = 0;
  static String _languageCode = '';

  static int get startTime => _startTime;
  static int get cupImage => _cupImage;
  static bool get wakelockEnabled => _wakelockEnabled;
  static bool get soundEnabled => _soundEnabled;
  static double get soundVolume => _soundVolume;
  static int get soundSelect => _soundSelect;
  static bool get vibrateEnabled => _vibrateEnabled;
  static int get schemeColor => _schemeColor;
  static int get themeNumber => _themeNumber;
  static String get languageCode => _languageCode;

  static Future<void> ensureReady() async {
    if (_ready) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    //
    _startTime = (prefs.getInt(_prefStartTime) ?? 3).clamp(1, 6);
    _cupImage = (prefs.getInt(_prefCupImage) ?? 1).clamp(1, 5);
    _wakelockEnabled = prefs.getBool(_prefWakelockEnabled) ?? true;
    _soundEnabled = prefs.getBool(_prefSoundEnabled) ?? true;
    _soundVolume = (prefs.getDouble(_prefSoundVolume) ?? 1.0).clamp(0.0, 1.0);
    _soundSelect = (prefs.getInt(_prefSoundSelect) ?? 0).clamp(0, finishSounds.length - 1);
    _vibrateEnabled = prefs.getBool(_prefVibrateEnabled) ?? true;
    _schemeColor = (prefs.getInt(_prefSchemeColor) ?? 40).clamp(0, 360);
    _themeNumber = (prefs.getInt(_prefThemeNumber) ?? 0).clamp(0, 2);
    _languageCode = prefs.getString(_prefLanguageCode) ?? ui.PlatformDispatcher.instance.locale.languageCode;
    _languageCode = _resolveLanguageCode(_languageCode);
    _ready = true;
  }

  static String _resolveLanguageCode(String code) {
    final supported = AppLocalizations.supportedLocales;
    if (supported.any((l) => l.languageCode == code)) {
      return code;
    } else {
      return '';
    }
  }

  static Future<void> setStartTime(int value) async {
    _startTime = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefStartTime, value);
  }

  static Future<void> setCupImage(int value) async {
    _cupImage = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefCupImage, value);
  }

  static Future<void> setWakelockEnabled(bool value) async {
    _wakelockEnabled = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefWakelockEnabled, value);
  }

  static Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefSoundEnabled, value);
  }

  static Future<void> setSoundVolume(double value) async {
    _soundVolume = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefSoundVolume, value);
  }

  static Future<void> setSoundSelect(int value) async {
    _soundSelect = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefSoundSelect, value);
  }

  static Future<void> setVibrateEnabled(bool value) async {
    _vibrateEnabled = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefVibrateEnabled, value);
  }

  static Future<void> setSchemeColor(int value) async {
    _schemeColor = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefSchemeColor, value);
  }

  static Future<void> setThemeNumber(int value) async {
    _themeNumber = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefThemeNumber, value);
  }

  static Future<void> setLanguageCode(String value) async {
    _languageCode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefLanguageCode, value);
  }

}
