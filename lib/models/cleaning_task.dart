// lib/models/cleaning_task.dart

import 'dart:convert';

/// Model representing a cleaning task (ongoing or completed).
class CleaningTask {
  final String id; // unique id (use DateTime.now().millisecondsSinceEpoch.toString())
  final String toiletName;
  final DateTime startTime;
  DateTime? endTime;

  final List<String> beforePhotos; // file paths or remote URLs
  final String beforeRemarks;

  List<String> afterPhotos; // file paths or remote URLs (mutable)
  String afterRemarks;

  final double startLatitude;
  final double startLongitude;

  double? endLatitude;
  double? endLongitude;

  /// 'ongoing' or 'completed'
  String status;

  CleaningTask({
    required this.id,
    required this.toiletName,
    required this.startTime,
    this.endTime,
    required this.beforePhotos,
    required this.beforeRemarks,
    this.afterPhotos = const [],
    this.afterRemarks = '',
    required this.startLatitude,
    required this.startLongitude,
    this.endLatitude,
    this.endLongitude,
    required this.status,
  });

  /// Create a task from a Map (for storage / json)
  factory CleaningTask.fromMap(Map<String, dynamic> map) {
    return CleaningTask(
      id: map['id'] as String,
      toiletName: map['toiletName'] as String,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime'] as String) : null,
      beforePhotos: List<String>.from(map['beforePhotos'] ?? const []),
      beforeRemarks: map['beforeRemarks'] as String? ?? '',
      afterPhotos: List<String>.from(map['afterPhotos'] ?? const []),
      afterRemarks: map['afterRemarks'] as String? ?? '',
      startLatitude: (map['startLatitude'] as num).toDouble(),
      startLongitude: (map['startLongitude'] as num).toDouble(),
      endLatitude: map['endLatitude'] != null ? (map['endLatitude'] as num).toDouble() : null,
      endLongitude: map['endLongitude'] != null ? (map['endLongitude'] as num).toDouble() : null,
      status: map['status'] as String,
    );
  }

  /// Convert to Map (for local storage / json)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'toiletName': toiletName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'beforePhotos': beforePhotos,
      'beforeRemarks': beforeRemarks,
      'afterPhotos': afterPhotos,
      'afterRemarks': afterRemarks,
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      'endLatitude': endLatitude,
      'endLongitude': endLongitude,
      'status': status,
    };
  }

  /// Convenience: JSON string
  String toJson() => jsonEncode(toMap());

  /// Convenience: from JSON string
  factory CleaningTask.fromJson(String source) => CleaningTask.fromMap(jsonDecode(source));
}
