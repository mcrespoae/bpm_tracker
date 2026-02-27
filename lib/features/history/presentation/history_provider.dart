import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/bpm_record.dart';

class HistoryRepository {
  static const String _key = 'bpm_history';
  static const int maxItems = 20;

  Future<void> saveRecord(BPMRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_key) ?? [];
    history.insert(0, record.toJson());

    // Enforce item limit
    if (history.length > maxItems) {
      history.removeRange(maxItems, history.length);
    }

    await prefs.setStringList(_key, history);
  }

  Future<void> updateRecord(int index, BPMRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_key) ?? [];
    if (index >= 0 && index < history.length) {
      history[index] = record.toJson();
      await prefs.setStringList(_key, history);
    }
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
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> history = prefs.getStringList(_key) ?? [];

      final List<BPMRecord> records = [];
      for (final item in history) {
        try {
          records.add(BPMRecord.fromJson(item));
        } catch (e) {
          debugPrint('Skipping corrupted history record: $e');
        }
      }
      return records;
    } catch (e) {
      debugPrint('Failed to retrieve history: $e');
      return [];
    }
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

  Future<bool> addRecord(int bpm, double accuracy, double stdDev, String name) async {
    try {
      final record = BPMRecord(
        bpm: bpm,
        timestamp: DateTime.now(),
        accuracy: accuracy,
        stdDev: stdDev,
        name: name.isEmpty ? 'Unnamed' : name,
      );
      await ref.read(historyRepositoryProvider).saveRecord(record);
      state = await AsyncValue.guard(() => ref.read(historyRepositoryProvider).getHistory());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateRecordName(int index, String newName) async {
    try {
      final currentHistory = state.value ?? [];
      if (index >= 0 && index < currentHistory.length) {
        final oldRecord = currentHistory[index];
        final newRecord = BPMRecord(
          bpm: oldRecord.bpm,
          timestamp: oldRecord.timestamp,
          accuracy: oldRecord.accuracy,
          stdDev: oldRecord.stdDev,
          name: newName.isEmpty ? 'Unnamed' : newName,
        );
        await ref.read(historyRepositoryProvider).updateRecord(index, newRecord);
        state = await AsyncValue.guard(() => ref.read(historyRepositoryProvider).getHistory());
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
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

class ScrollingRecordNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void setIndex(int? index) {
    state = index;
  }
}

final scrollingRecordIndexProvider = NotifierProvider<ScrollingRecordNotifier, int?>(() {
  return ScrollingRecordNotifier();
});
