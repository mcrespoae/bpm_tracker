import 'dart:math';

class BPMStats {
  final double bpm;
  final double stdDev;
  final double accuracy;

  BPMStats({required this.bpm, required this.stdDev, required this.accuracy});
}

class BPMCalculator {
  static const int maxTaps = 25;
  static const int minTapsForStats = 4;
  static const int timeoutMs = 2000;

  static BPMStats calculateStats(List<DateTime> taps) {
    if (taps.length < 2) {
      return BPMStats(bpm: 0, stdDev: 0, accuracy: 0);
    }

    List<int> intervals = [];
    for (int i = 1; i < taps.length; i++) {
      intervals.add(taps[i].difference(taps[i - 1]).inMilliseconds);
    }

    int n = intervals.length;
    double totalWeight = 0;
    double weightedSum = 0;

    // Plateau size: Latest 4 intervals get full 1.0 weight
    const int plateau = 4;
    // Target: Oldest interval at max capacity should have 0.1 weight
    const double minWeight = 0.1;
    // Max intervals possible in buffer
    final int maxIntervals = maxTaps - 1;

    // Calculate base decay rate: weight = pow(r, distance_from_plateau)
    // 0.1 = 1.0 * pow(r, maxIntervals - plateau)
    final double r = pow(minWeight, 1.0 / (maxIntervals - plateau)).toDouble();

    List<double> weights = List.generate(n, (i) {
      int distanceFromEnd = (n - 1) - i;
      if (distanceFromEnd < plateau) {
        return 1.0;
      } else {
        return pow(r, distanceFromEnd - (plateau - 1)).toDouble();
      }
    });

    for (int i = 0; i < n; i++) {
      weightedSum += intervals[i] * weights[i];
      totalWeight += weights[i];
    }


    double weightedMean = weightedSum / totalWeight;
    if (weightedMean == 0) return BPMStats(bpm: 0, stdDev: 0, accuracy: 0);

    // WEIGHTED ENGINE:
    double weightedSumOfSquaredDiffs = 0;
    for (int i = 0; i < n; i++) {
        weightedSumOfSquaredDiffs += weights[i] * pow(intervals[i] - weightedMean, 2);
    }

    double weightedVariance = weightedSumOfSquaredDiffs / totalWeight;
    double weightedStdDev = sqrt(weightedVariance);

    // Accuracy as 1 - Coefficient of Variation (using the unified mean and stdDev)
    double cv = weightedStdDev / weightedMean;
    double accuracy = (1.0 - cv).clamp(0.0, 1.0) * 100;

    double bpm = 60000 / weightedMean;

    return BPMStats(
      bpm: bpm,
      stdDev: weightedStdDev,
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
