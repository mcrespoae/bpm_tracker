import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/bpm_record.dart';

class HistoryRepository {
  static const String _key = 'bpm_history';
  static const int _maxItems = 10;

  Future<void> saveRecord(BPMRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_key) ?? [];
    history.insert(0, record.toJson());

    // Enforce 10 item limit
    if (history.length > _maxItems) {
      history.removeRange(_maxItems, history.length);
    }

    await prefs.setStringList(_key, history);
  }

  Future<void> deleteRecord(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_key) ?? [];
    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      await prefs.setStringList(_key, history);
    }
  }

  Future<List<BPMRecord>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_key) ?? [];
    return history.map((item) => BPMRecord.fromJson(item)).toList();
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

final historyRepositoryProvider = Provider((ref) => HistoryRepository());

class HistoryNotifier extends AsyncNotifier<List<BPMRecord>> {
  @override
  FutureOr<List<BPMRecord>> build() {
    return ref.read(historyRepositoryProvider).getHistory();
  }

  Future<void> addRecord(int bpm, double accuracy) async {
    final record = BPMRecord(bpm: bpm, timestamp: DateTime.now(), accuracy: accuracy);
    await ref.read(historyRepositoryProvider).saveRecord(record);
    state = await AsyncValue.guard(() => ref.read(historyRepositoryProvider).getHistory());
  }

  Future<void> removeRecord(int index) async {
    await ref.read(historyRepositoryProvider).deleteRecord(index);
    state = await AsyncValue.guard(() => ref.read(historyRepositoryProvider).getHistory());
  }

  Future<void> clear() async {
     await ref.read(historyRepositoryProvider).clearHistory();
     state = const AsyncValue.data([]);
  }
}

final historyProvider = AsyncNotifierProvider<HistoryNotifier, List<BPMRecord>>(() {
  return HistoryNotifier();
});
