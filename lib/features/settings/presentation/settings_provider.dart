import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool isHapticsEnabled;
  final bool isOverrideEnabled;

  SettingsState({
    required this.isHapticsEnabled,
    required this.isOverrideEnabled,
  });

  SettingsState copyWith({
    bool? isHapticsEnabled,
    bool? isOverrideEnabled,
  }) {
    return SettingsState(
      isHapticsEnabled: isHapticsEnabled ?? this.isHapticsEnabled,
      isOverrideEnabled: isOverrideEnabled ?? this.isOverrideEnabled,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  static const _hapticsKey = 'haptics_enabled';
  static const _overrideKey = 'override_enabled';

  @override
  SettingsState build() {
    // Initial state
    state = SettingsState(
      isHapticsEnabled: true,
      isOverrideEnabled: true,
    );
    _loadSettings();
    return state;
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final haptics = prefs.getBool(_hapticsKey) ?? true;
      final override = prefs.getBool(_overrideKey) ?? true;
      state = state.copyWith(
        isHapticsEnabled: haptics,
        isOverrideEnabled: override,
      );
    } catch (e) {
      debugPrint('Failed to load settings: $e');
    }
  }

  Future<void> toggleHaptics(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticsKey, value);
    state = state.copyWith(isHapticsEnabled: value);
  }

  Future<void> toggleOverride(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_overrideKey, value);
    state = state.copyWith(isOverrideEnabled: value);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
