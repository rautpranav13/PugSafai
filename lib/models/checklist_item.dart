// lib/models/checklist_item.dart
import 'dart:convert';

/// Model for each checklist item inside "description" array
class ChecklistItem {
  final int id;
  final String keyName; // API field 'key'
  final String label;
  final String category;

  ChecklistItem({
    required this.id,
    required this.keyName,
    required this.label,
    required this.category,
  });

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'] ?? 0,
      keyName: json['key'] ?? '',
      label: json['label'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': keyName,
      'label': label,
      'category': category,
    };
  }

  /// Parse list from JSON array
  static List<ChecklistItem> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((e) => ChecklistItem.fromJson(e)).toList();
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
