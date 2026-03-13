import 'package:flutter/foundation.dart';

class RamenTickTimer {
  final ValueNotifier<int> timerCounter = ValueNotifier<int>(180);
  final ValueNotifier<bool> isTimerActive = ValueNotifier<bool>(true);

  void stop() {
    isTimerActive.value = false;
  }

  void resume() {
    isTimerActive.value = true;
  }

  void setTimerCounter(int sec) {
    timerCounter.value = sec;
  }

  void addTimerCounter(int sec) {
    timerCounter.value += sec;
  }

  String getTimeStr() {
    final int counter = timerCounter.value;
    if (counter > 0) {
      int minute = (counter / 60).floor();
      int second = (counter % 60);
      return '$minute:${second.toString().padLeft(2, '0')}';
    } else {
      final int absCounter = counter.abs();
      int minute = (absCounter / 60).floor();
      int second = (absCounter % 60);
      return '-$minute:${second.toString().padLeft(2, '0')}';
    }
  }

  void dispose() {
    timerCounter.dispose();
    isTimerActive.dispose();
  }
}