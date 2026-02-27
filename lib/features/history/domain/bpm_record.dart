import 'dart:convert';

class BPMRecord {
  final int bpm;
  final DateTime timestamp;
  final double accuracy;
  final double stdDev;
  final String name;

  BPMRecord({
    required this.bpm,
    required this.timestamp,
    required this.accuracy,
    required this.stdDev,
    this.name = 'Unnamed',
  });

  Map<String, dynamic> toMap() {
    return {
      'bpm': bpm,
      'timestamp': timestamp.toIso8601String(),
      'accuracy': accuracy,
      'stdDev': stdDev,
      'name': name,
    };
  }

  factory BPMRecord.fromMap(Map<String, dynamic> map) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(map['timestamp']);
    } catch (_) {
      parsedDate = DateTime.now();
    }

    return BPMRecord(
      bpm: map['bpm']?.toInt() ?? 0,
      timestamp: parsedDate,
      accuracy: (map['accuracy'] ?? 0.0).toDouble(),
      stdDev: (map['stdDev'] ?? 0.0).toDouble(),
      name: map['name'] ?? 'Unnamed',
    );
  }

  String toJson() => json.encode(toMap());

  factory BPMRecord.fromJson(String source) => BPMRecord.fromMap(json.decode(source));
}
