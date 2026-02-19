import 'dart:math';

class BPMStats {
  final double bpm;
  final double stdDev;
  final double accuracy;

  BPMStats({required this.bpm, required this.stdDev, required this.accuracy});
}

class BPMCalculator {
  static const int maxTaps = 25;
  static const int timeoutMs = 2000;

  static BPMStats calculateStats(List<DateTime> taps) {
    if (taps.length < 2) {
      return BPMStats(bpm: 0, stdDev: 0, accuracy: 0);
    }

    List<int> intervals = [];
    for (int i = 1; i < taps.length; i++) {
      intervals.add(taps[i].difference(taps[i - 1]).inMilliseconds);
    }

    double mean = intervals.reduce((a, b) => a + b) / intervals.length;
    if (mean == 0) return BPMStats(bpm: 0, stdDev: 0, accuracy: 0);

    double sumOfSquaredDiffs = intervals.map((i) => pow(i - mean, 2).toDouble()).reduce((a, b) => a + b);
    double variance = sumOfSquaredDiffs / intervals.length;
    double stdDev = sqrt(variance);

    // Accuracy as 1 - Coefficient of Variation
    // CV = stdDev / mean. If CV = 0, accuracy = 100%.
    // We cap it to avoid extreme values.
    double cv = stdDev / mean;
    double accuracy = (1.0 - cv).clamp(0.0, 1.0) * 100;

    double bpm = 60000 / mean;

    return BPMStats(
      bpm: bpm,
      stdDev: stdDev,
      accuracy: accuracy,
    );
  }

  static List<DateTime> cleanTaps(List<DateTime> taps) {
    if (taps.isEmpty) return [];

    final now = DateTime.now();
    // We keep this check for manual reset logic,
    // but the inactivity timer in Notifier will handle the "Finished" state.
    if (now.difference(taps.last).inMilliseconds > 5000) {
      return [];
    }

    if (taps.length > maxTaps) {
      return taps.sublist(taps.length - maxTaps);
    }

    return taps;
  }
}
