import 'package:advanced_haptics/advanced_haptics.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

class HapticService {
  bool _advancedSupported = false;
  bool _vibrationSupported = false;

  HapticService() {
    _init();
  }

  Future<void> _init() async {
    try {
      // Check for advanced_haptics support
      _advancedSupported = await AdvancedHaptics.hasCustomHapticsSupport();

      // Check for vibration support
      if (await Vibration.hasVibrator()) {
        _vibrationSupported = true;
      }
    } catch (e) {
      debugPrint('HapticService Init Error: $e');
    }
  }

  /// High-fidelity Tap: Light, quick impulse
  Future<void> playTap() async {
    try {
      if (_advancedSupported) {
        // Light impact simulation using waveform
        // 0ms wait, 15ms vibrate at 80 amplitude
        await AdvancedHaptics.playWaveform([0, 15], [0, 80]);
      } else if (_vibrationSupported) {
        // Fallback to vibration with a very short duration
        Vibration.vibrate(duration: 40, amplitude: 255);
      } else {
        // Baseline fallback
        await HapticFeedback.lightImpact();
      }
    } catch (e) {
      // Emergency fallback
      HapticFeedback.selectionClick();
    }
  }

  /// High-fidelity Success: Distinct double-pulse or heartbeat
  Future<void> playSuccess() async {
    try {
      if (_advancedSupported) {
        await AdvancedHaptics.success();
      } else if (_vibrationSupported) {
        // Custom double-pulse pattern for Vibration package
        // wait 0ms, vibrate 50ms, wait 100ms, vibrate 100ms
        Vibration.vibrate(
          pattern: [0, 50, 100, 100],
          intensities: [0, 120, 0, 255],
        );
      } else {
        // Baseline fallback
        await HapticFeedback.heavyImpact();
      }
    } catch (e) {
      // Emergency fallback
      HapticFeedback.vibrate();
    }
  }
}

final hapticServiceProvider = Provider((ref) => HapticService());
