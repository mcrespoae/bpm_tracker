import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metra/features/tracker/domain/bpm_calculator.dart';
import 'package:metra/features/settings/presentation/settings_provider.dart';

class BPMState {
  final int bpm;
  final List<DateTime> taps;
  final double accuracy;
  final double stdDev;
  final bool isFinished;

  BPMState({
    this.bpm = 0,
    this.taps = const [],
    this.accuracy = 0,
    this.stdDev = 0,
    this.isFinished = false,
  });

  BPMState copyWith({
    int? bpm,
    List<DateTime>? taps,
    double? accuracy,
    double? stdDev,
    bool? isFinished,
  }) {
    return BPMState(
      bpm: bpm ?? this.bpm,
      taps: taps ?? this.taps,
      accuracy: accuracy ?? this.accuracy,
      stdDev: stdDev ?? this.stdDev,
      isFinished: isFinished ?? this.isFinished,
    );
  }
}

class BPMNotifier extends Notifier<BPMState> {
  Timer? _inactivityTimer;

  @override
  BPMState build() {
    ref.onDispose(() => _inactivityTimer?.cancel());
    return BPMState();
  }

  bool get _hapticsEnabled => ref.read(settingsProvider).isHapticsEnabled;

  void tap() {
    if (state.isFinished) {
      reset();
    }
    _inactivityTimer?.cancel();

    // Haptic feedback on tap
    if (_hapticsEnabled) {
      HapticFeedback.lightImpact();
    }

    final now = DateTime.now();
    final List<DateTime> currentTaps = [...state.taps, now];
    final List<DateTime> updatedTaps = BPMCalculator.cleanTaps(currentTaps);
    final stats = BPMCalculator.calculateStats(updatedTaps);

    state = state.copyWith(
      bpm: stats.bpm.round(),
      taps: updatedTaps,
      accuracy: stats.accuracy,
      stdDev: stats.stdDev,
      isFinished: false,
    );

    // Start inactivity timer
    _inactivityTimer = Timer(const Duration(seconds: 2), () {
      if (state.taps.length >= BPMCalculator.minTapsForStats) {
        _finishSession();
      } else if (state.taps.isNotEmpty) {
        reset();
      }
    });
  }

  void _finishSession() {
    if (_hapticsEnabled) {
      HapticFeedback.heavyImpact();
    }
    state = state.copyWith(isFinished: true);
  }

  void reset() {
    _inactivityTimer?.cancel();
    state = BPMState();
  }
}

final bpmProvider = NotifierProvider<BPMNotifier, BPMState>(() {
  return BPMNotifier();
});
