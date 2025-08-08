// lib/models/checklist_item.dart
class ChecklistItem {
  final int id;
  final String key;
  final String label;
  final String category;
  bool isChecked; // for UI state

  ChecklistItem({
    required this.id,
    required this.key,
    required this.label,
    required this.category,
    this.isChecked = false,
  });

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'] ?? 0,
      key: json['key'] ?? '',
      label: json['label'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'label': label,
      'category': category,
      'isChecked': isChecked,
    };
  }

  ChecklistItem copyWith({bool? isChecked}) {
    return ChecklistItem(
      id: id,
      key: key,
      label: label,
      category: category,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
