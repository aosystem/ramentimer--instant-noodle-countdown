import 'package:flutter/material.dart';
import 'package:ramentimer/theme_color.dart';

class AppCondition {
  late ThemeColor _themeColor;
  static const int ready = 0;
  static const int complete = 1;

  final ValueNotifier<int> gameCondition = ValueNotifier<int>(ready);

  void setThemeColor(ThemeColor themeColor) {
    _themeColor = themeColor;
  }

  void setGameCondition(int cond) {
    gameCondition.value = cond;
  }

  Color stageColor() {
    if (gameCondition.value == ready) {
      return _themeColor.mainCanvasClose;
    } else if (gameCondition.value == complete) {
      return _themeColor.mainCanvasOpen;
    }
    return _themeColor.mainCanvasClose;
  }

  Color bgColor() {
    if (gameCondition.value == ready) {
      return _themeColor.mainCanvasClose;
    } else if (gameCondition.value == complete) {
      return _themeColor.mainCanvasOpen;
    }
    return _themeColor.mainCanvasClose;
  }

  void dispose() {
    gameCondition.dispose();
  }
}