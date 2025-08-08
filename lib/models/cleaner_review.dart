// lib/models/cleaner_review.dart
import 'checklist_item.dart';

class CleanerReview {
  final String id; // task id from backend
  final String userId; // cleaner's user id
  final String locationId;
  final String locationName;
  final List<String> beforePhotos;
  final List<String> afterPhotos;
  final String? initialRemarks;
  final String? completionRemarks;
  final List<ChecklistItem> checklist;
  final DateTime createdAt;
  final DateTime? updatedAt; // null means ongoing task

  CleanerReview({
    required this.id,
    required this.userId,
    required this.locationId,
    required this.locationName,
    required this.beforePhotos,
    required this.afterPhotos,
    required this.initialRemarks,
    required this.completionRemarks,
    required this.checklist,
    required this.createdAt,
    this.updatedAt,
  });

  factory CleanerReview.fromJson(Map<String, dynamic> json) {
    return CleanerReview(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      locationId: json['location_id'] ?? '',
      locationName: json['location_name'] ?? '',
      beforePhotos: List<String>.from(json['before_photos'] ?? []),
      afterPhotos: List<String>.from(json['after_photos'] ?? []),
      initialRemarks: json['initial_remarks'],
      completionRemarks: json['completion_remarks'],
      checklist: (json['checklist'] as List<dynamic>? ?? [])
          .map((item) => ChecklistItem.fromJson(item))
          .toList(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'location_id': locationId,
      'location_name': locationName,
      'before_photos': beforePhotos,
      'after_photos': afterPhotos,
      'initial_remarks': initialRemarks,
      'completion_remarks': completionRemarks,
      'checklist': checklist.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  CleanerReview copyWith({
    List<String>? beforePhotos,
    List<String>? afterPhotos,
    String? initialRemarks,
    String? completionRemarks,
    List<ChecklistItem>? checklist,
    DateTime? updatedAt,
  }) {
    return CleanerReview(
      id: id,
      userId: userId,
      locationId: locationId,
      locationName: locationName,
      beforePhotos: beforePhotos ?? this.beforePhotos,
      afterPhotos: afterPhotos ?? this.afterPhotos,
      initialRemarks: initialRemarks ?? this.initialRemarks,
      completionRemarks: completionRemarks ?? this.completionRemarks,
      checklist: checklist ?? this.checklist,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
