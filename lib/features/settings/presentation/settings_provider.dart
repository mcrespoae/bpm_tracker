import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final bool isHapticsEnabled;

  SettingsState({
    required this.isHapticsEnabled,
  });

  SettingsState copyWith({
    bool? isHapticsEnabled,
  }) {
    return SettingsState(
      isHapticsEnabled: isHapticsEnabled ?? this.isHapticsEnabled,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  static const _hapticsKey = 'haptics_enabled';

  @override
  SettingsState build() {
    // Initial state
    state = SettingsState(isHapticsEnabled: true);
    _loadSettings();
    return state;
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool(_hapticsKey) ?? true;
    state = state.copyWith(isHapticsEnabled: isEnabled);
  }

  Future<void> toggleHaptics(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hapticsKey, value);
    state = state.copyWith(isHapticsEnabled: value);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
