import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import "package:audioplayers/audioplayers.dart";
import 'package:vibration/vibration.dart';

import 'package:ramentimer/l10n/app_localizations.dart';
import 'package:ramentimer/ramen_tick_timer.dart';
import 'package:ramentimer/app_condition.dart';
import 'package:ramentimer/ad_manager.dart';
import 'package:ramentimer/main.dart';
import 'package:ramentimer/model.dart';
import 'package:ramentimer/theme_color.dart';
import 'package:ramentimer/loading_screen.dart';
import 'package:ramentimer/ad_banner_widget.dart';
import 'package:ramentimer/parse_locale_tag.dart';
import 'package:ramentimer/setting_page.dart';
import 'package:ramentimer/theme_mode_number.dart';
import 'package:ramentimer/const_value.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});
  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  Timer? _timer;
  final RamenTickTimer _ramenTickTimer = RamenTickTimer();
  late AppCondition _appCondition;
  late AdManager _adManager;
  late AudioPlayer _audioPlayer;
  late ThemeColor _themeColor;
  bool _isReady = false;
  bool _isFirst = true;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() async {
    _adManager = AdManager();
    _audioPlayer = AudioPlayer();
    _appCondition = AppCondition();
    _ramenTickTimerStart();
    _wakelock();
    _ramenTickTimer.timerCounter.addListener(_onTimerChanged);
    setState(() {
      _isReady = true;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ramenTickTimer.timerCounter.removeListener(_onTimerChanged);
    _appCondition.dispose();
    _ramenTickTimer.dispose();
    WakelockPlus.disable();
    _adManager.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _wakelock() {
    if (Model.wakelockEnabled) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }
  }

  void _onTimerChanged() async {
    final timerCounter = _ramenTickTimer.timerCounter.value;
    if (timerCounter > 0) {
      _appCondition.setGameCondition(AppCondition.ready);
    } else {
      _appCondition.setGameCondition(AppCondition.complete);
    }
    if (timerCounter == 0) {
      if (Model.soundEnabled && Model.soundVolume > 0) {
        final selected = finishSounds.firstWhere(
          (s) => s['key'] == Model.soundSelect,
          orElse: () => {},
        );
        if (selected.isNotEmpty) {
          _audioPlayer.setVolume(Model.soundVolume);
          _audioPlayer.play(AssetSource('sound/${selected['file']}'));
        }
      }
      if (await Vibration.hasVibrator()) {
        if (Model.vibrateEnabled) {
          Vibration.vibrate(duration: 500);
        }
      }
    }
  }

  void _ramenTickTimerStart() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_ramenTickTimer.isTimerActive.value) {
        _ramenTickTimer.addTimerCounter(-1);
      }
    });
  }

  void _onClickMinuteButton(int minute) {
    if (Model.soundEnabled && Model.soundVolume > 0) {
      _audioPlayer.setVolume(Model.soundVolume);
      _audioPlayer.play(AssetSource('sound/start.mp3'));
    }
    _ramenTickTimer.setTimerCounter(minute * 60);
    Model.setStartTime(minute);
  }

  void _onClickSecondButton(int second) {
    if (second > 0) {
      if (Model.soundEnabled && Model.soundVolume > 0) {
        _audioPlayer.setVolume(Model.soundVolume);
        _audioPlayer.play(AssetSource('sound/push1.mp3'));
      }
    } else {
      if (Model.soundEnabled && Model.soundVolume > 0) {
        _audioPlayer.setVolume(Model.soundVolume);
        _audioPlayer.play(AssetSource('sound/push2.mp3'));
      }
    }
    _ramenTickTimer.addTimerCounter(second);
  }

  void _onClickStopButton() {
    if (Model.soundEnabled && Model.soundVolume > 0) {
      _audioPlayer.setVolume(Model.soundVolume);
      _audioPlayer.play(AssetSource('sound/stop.mp3'));
    }
    _ramenTickTimer.stop();
  }

  void _onClickStartButton() {
    if (Model.soundEnabled && Model.soundVolume > 0) {
      _audioPlayer.setVolume(Model.soundVolume);
      _audioPlayer.play(AssetSource('sound/start.mp3'));
    }
    _ramenTickTimer.resume();
  }

  void _onClickSetting() async {
    final updatedSettings = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingPage(),
      ),
    );
    if (updatedSettings != null) {
      if (mounted) {
        final mainState = context.findAncestorStateOfType<MainAppState>();
        if (mainState != null) {
          mainState
            ..locale = parseLocaleTag(Model.languageCode)
            ..themeMode = ThemeModeNumber.numberToThemeMode(Model.themeNumber)
            ..setState(() {});
          setState(() {
            _isFirst = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return LoadingScreen();
    }
    if (_isFirst) {
      _isFirst = false;
      _themeColor = ThemeColor(themeNumber: Model.themeNumber, context: context);
      _appCondition.setThemeColor(_themeColor);
    }
    return Scaffold(
      appBar: null,
      backgroundColor: _themeColor.mainHeaderBack,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              _menuBar(),
              ValueListenableBuilder<int>(
                valueListenable: _appCondition.gameCondition,
                builder: (context, gameCondition, child) {
                  return Expanded(
                    child: Container(
                      color: _appCondition.bgColor(),
                      padding: const EdgeInsets.only(
                        top: 0,
                        left: 8,
                        right: 8,
                        bottom: 10,
                      ),
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1 / 1.3,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: _appCondition.stageColor(),
                            child: _timerDisplay(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AdBannerWidget(adManager: _adManager),
    );
  }

  Widget _menuBar() {
    final l = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(color: _themeColor.mainHeaderBack),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _ActionButton(
                themeColor: _themeColor,
                label: l.min1,
                onPressed: () => _onClickMinuteButton(1),
              ),
              _ActionButton(
                themeColor: _themeColor,
                label: l.min2,
                onPressed: () => _onClickMinuteButton(2),
              ),
              _ActionButton(
                themeColor: _themeColor,
                label: l.min3,
                onPressed: () => _onClickMinuteButton(3),
              ),
              _ActionButton(
                themeColor: _themeColor,
                label: l.min4,
                onPressed: () => _onClickMinuteButton(4),
              ),
              _ActionButton(
                themeColor: _themeColor,
                label: l.min5,
                onPressed: () => _onClickMinuteButton(5),
              ),
              _ActionButton(
                themeColor: _themeColor,
                label: l.min6,
                onPressed: () => _onClickMinuteButton(6),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              _ActionButton(
                themeColor: _themeColor,
                label: l.minus10sec,
                onPressed: () => _onClickSecondButton(-10),
              ),
              _ActionButton(
                themeColor: _themeColor,
                label: l.plus10sec,
                onPressed: () => _onClickSecondButton(10),
              ),
              _ActionButton(
                  themeColor: _themeColor,
                  label: l.stop,
                  onPressed: _onClickStopButton
              ),
              _ActionButton(
                  themeColor: _themeColor,
                  label: l.resume,
                  onPressed: _onClickStartButton
              ),
              IconButton(
                icon: Icon(Icons.settings, color: _themeColor.mainHeaderFore),
                tooltip: AppLocalizations.of(context)!.setting,
                onPressed: _onClickSetting,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _timerDisplay() {
    return ValueListenableBuilder<int>(
      valueListenable: _ramenTickTimer.timerCounter,
      builder: (context, timerCounter, child) {
        final String cupImage = (timerCounter <= 0) ? _themeColor.cupOpen : _themeColor.cupClose;
        final Color timeColor = (timerCounter <= 0) ? _themeColor.ramenTimerOpen : _themeColor.ramenTimerClose;
        final String timeStr = _ramenTickTimer.getTimeStr();
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: Image.asset(
                cupImage,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            AspectRatio(
              aspectRatio: 1 / 1,
              child: Container(
                alignment: Alignment.center,
                child: FractionallySizedBox(
                  widthFactor: 0.26,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      timeStr,
                      style: TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.w900,
                        color: timeColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.themeColor,required this.label,required this.onPressed});
  final ThemeColor themeColor;
  final String label;
  final VoidCallback onPressed;

  ButtonStyle get _buttonStyle => ElevatedButton.styleFrom(
    elevation: 0,
    backgroundColor: themeColor.mainHeaderBack,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: _buttonStyle,
        child: Text(label,style: TextStyle(color: themeColor.mainHeaderFore)),
      ),
    );
  }
}
