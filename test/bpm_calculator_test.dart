import 'package:flutter_test/flutter_test.dart';
import 'package:metra/features/tracker/domain/bpm_calculator.dart';

void main() {
  group('BPMCalculator Tests', () {
    test('calculateStats returns zero for less than 2 taps', () {
      final taps = [DateTime.now()];
      final stats = BPMCalculator.calculateStats(taps);
      expect(stats.bpm, 0);
      expect(stats.accuracy, 0);
      expect(stats.stdDev, 0);
    });

    test('Stable rhythm returns zero stdDev and high accuracy', () {
      final now = DateTime.now();
      // 5 taps at 1 second intervals = 60 BPM
      final taps = [
        now.subtract(const Duration(seconds: 4)),
        now.subtract(const Duration(seconds: 3)),
        now.subtract(const Duration(seconds: 2)),
        now.subtract(const Duration(seconds: 1)),
        now,
      ];

      final stats = BPMCalculator.calculateStats(taps);
      expect(stats.bpm, closeTo(60.0, 0.1));
      expect(stats.stdDev, 0.0);
      expect(stats.accuracy, 100.0);
    });

    test('Plateau logic: latest 4 taps have weight 1.0', () {
      // This is internal logic, but we can verify it by its effect
      // High bpm for older taps, low bpm for newest 4.
      // If weights are 1.0 for newest 4, mean should be biased towards them.
      final now = DateTime.now();

      // 10 intervals (11 taps)
      // Old intervals: 1000ms (60 BPM) x 6
      // Newest 4 intervals: 500ms (120 BPM) x 4
      List<DateTime> taps = [now.subtract(const Duration(milliseconds: 8000))];
      for (int i = 0; i < 6; i++) {
        taps.add(taps.last.add(const Duration(milliseconds: 1000)));
      }
      for (int i = 0; i < 4; i++) {
        taps.add(taps.last.add(const Duration(milliseconds: 500)));
      }

      final stats = BPMCalculator.calculateStats(taps);
      // If they were unweighted, mean would be (6*1000 + 4*500) / 10 = 800ms (75 BPM)
      // Because newest 4 are 1.0 and old are lower, BPM should be higher than 75.
      expect(stats.bpm, greaterThan(75.0));
      expect(stats.bpm, lessThan(120.0));
    });

    test('Honest scoring: high accuracy for consistent early taps', () {
      final now = DateTime.now();
      // Exactly 5 taps (4 intervals) - should show 100% accuracy immediately
      final taps = List.generate(5, (i) => now.subtract(Duration(seconds: 4 - i)));

      final stats = BPMCalculator.calculateStats(taps);
      expect(stats.accuracy, 100.0);
    });

    test('CleanTaps: removes old taps after 5 seconds of inactivity', () {
      final oldTap = DateTime.now().subtract(const Duration(seconds: 6));
      final taps = [oldTap];
      final cleaned = BPMCalculator.cleanTaps(taps);
      expect(cleaned, isEmpty);
    });

    test('CleanTaps: limits buffer to maxTaps (25)', () {
      final now = DateTime.now();
      final taps = List.generate(30, (i) => now.add(Duration(milliseconds: i * 500)));
      final cleaned = BPMCalculator.cleanTaps(taps);
      expect(cleaned.length, 25);
      expect(cleaned.last, taps.last);
    });
  });
}
