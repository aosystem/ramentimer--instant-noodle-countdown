import 'package:flutter/material.dart';

import 'package:ramentimer/model.dart';

class ThemeColor {
  final int? themeNumber;
  final BuildContext context;

  ThemeColor({this.themeNumber, required this.context});

  Brightness get _effectiveBrightness {
    switch (themeNumber) {
      case 1:
        return Brightness.light;
      case 2:
        return Brightness.dark;
      default:
        return Theme.of(context).brightness;
    }
  }

  Color _getRainbowAccentColor(int hue, double saturation, double value) {
    return HSVColor.fromAHSV(1.0, hue.toDouble(), saturation, value).toColor();
  }

  bool get _isLight => _effectiveBrightness == Brightness.light;

  //main page
  Color get mainHeaderBack => _isLight
      ? _getRainbowAccentColor(Model.schemeColor, 0.7, 0.5)
      : _getRainbowAccentColor(Model.schemeColor, 1, 0.2);
  Color get mainHeaderFore => _isLight ? Color.fromRGBO(255, 255, 255, 1.0) : Color.fromRGBO(160, 160, 160, 1.0);
  Color get mainCanvasClose => _isLight ? Color.fromRGBO(255, 255, 255, 1.0) : Color.fromRGBO(17, 17, 17, 1.0);
  Color get mainCanvasOpen => _isLight ? Color.fromRGBO(255, 255, 255, 1.0) : Color.fromRGBO(142, 9, 0, 1.0);
  Color get ramenTimerClose => _isLight ? Color.fromRGBO(255, 255, 0, 1.0) : Color.fromRGBO(255, 230, 0, 1.0);
  Color get ramenTimerOpen => _isLight ? Color.fromRGBO(255,0,0,0.6) : Color.fromRGBO(255, 0, 0, 0.6);
  String get cupClose {
    if (Model.cupImage == 1) {
      return 'assets/image/cup01_close.webp';
    } else if (Model.cupImage == 2) {
      return 'assets/image/cup02_close.webp';
    } else if (Model.cupImage == 3) {
      return 'assets/image/cup03_close.webp';
    } else if (Model.cupImage == 4) {
      return 'assets/image/cup04_close.webp';
    } else if (Model.cupImage == 5) {
      return 'assets/image/cup05_close.webp';
    }
    return 'assets/image/cup01_close.webp';
  }
  String get cupOpen {
    if (Model.cupImage == 1) {
      return 'assets/image/cup01_open.webp';
    } else if (Model.cupImage == 2) {
      return 'assets/image/cup02_open.webp';
    } else if (Model.cupImage == 3) {
      return 'assets/image/cup03_open.webp';
    } else if (Model.cupImage == 4) {
      return 'assets/image/cup04_open.webp';
    } else if (Model.cupImage == 5) {
      return 'assets/image/cup05_open.webp';
    }
    return 'assets/image/cup01_open.webp';
  }

  //setting page
  Color get backColor => _isLight ? Colors.grey[300]! : Colors.grey[900]!;
  Color get cardColor => _isLight ? Colors.white : Colors.grey[800]!;
  Color get appBarForegroundColor => _isLight ? Colors.grey[700]! : Colors.white70;
  Color get dropdownColor => cardColor;
  Color get borderColor => _isLight ? Colors.grey[300]! : Colors.grey[700]!;
  Color get inputFillColor => _isLight ? Colors.grey[50]! : Colors.grey[900]!;

}
