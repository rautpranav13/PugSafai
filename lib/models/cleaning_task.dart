import 'dart:convert';

/// Model representing a cleaning task from API.
class CleaningTask {
  final String id;
  final String name; // Person or cleaner's name
  final String phone;
  final String remarks;
  final List<String> images; // General task images
  final double latitude;
  final double longitude;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String siteId;
  final String cleanerUserId;
  final List<dynamic> taskId; // Could be List<String> or List<int> depending on API
  final String? initialComment;
  final String? finalComment;
  final List<String> beforePhoto;
  final List<String> afterPhoto;
  final String status;

  CleaningTask({
    required this.id,
    required this.name,
    required this.phone,
    required this.remarks,
    required this.images,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.siteId,
    required this.cleanerUserId,
    required this.taskId,
    this.initialComment,
    this.finalComment,
    required this.beforePhoto,
    required this.afterPhoto,
    required this.status,
  });

  /// Create a task from a Map (API JSON)
  factory CleaningTask.fromMap(Map<String, dynamic> map) {
    return CleaningTask(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      remarks: map['remarks'] ?? '',
      images: List<String>.from(map['images'] ?? const []),
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
      createdAt: DateTime.tryParse(map['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updated_at'] ?? '') ?? DateTime.now(),
      siteId: map['site_id']?.toString() ?? '',
      cleanerUserId: map['cleaner_user_id']?.toString() ?? '',
      taskId: map['task_id'] ?? [],
      initialComment: map['initial_comment'],
      finalComment: map['final_comment'],
      beforePhoto: List<String>.from(map['before_photo'] ?? const []),
      afterPhoto: List<String>.from(map['after_photo'] ?? const []),
      status: map['status']?.trim() ?? '',
    );
  }

  /// Convert to Map (for local storage / sending to API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'remarks': remarks,
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'site_id': siteId,
      'cleaner_user_id': cleanerUserId,
      'task_id': taskId,
      'initial_comment': initialComment,
      'final_comment': finalComment,
      'before_photo': beforePhoto,
      'after_photo': afterPhoto,
      'status': status,
    };
  }

  /// JSON serialization
  String toJson() => jsonEncode(toMap());

  /// JSON deserialization
  factory CleaningTask.fromJson(String source) =>
      CleaningTask.fromMap(jsonDecode(source));
}
