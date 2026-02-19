import 'dart:convert';

class BPMRecord {
  final int bpm;
  final DateTime timestamp;
  final double accuracy;

  BPMRecord({
    required this.bpm,
    required this.timestamp,
    required this.accuracy,
  });

  Map<String, dynamic> toMap() {
    return {
      'bpm': bpm,
      'timestamp': timestamp.toIso8601String(),
      'accuracy': accuracy,
    };
  }

  factory BPMRecord.fromMap(Map<String, dynamic> map) {
    return BPMRecord(
      bpm: map['bpm']?.toInt() ?? 0,
      timestamp: DateTime.parse(map['timestamp']),
      accuracy: (map['accuracy'] ?? 0.0).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory BPMRecord.fromJson(String source) => BPMRecord.fromMap(json.decode(source));
}
