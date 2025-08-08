class ChecklistItem {
  final int id;
  final String key;
  final String label;
  final String category;

  const ChecklistItem({
    required this.id,
    required this.key,
    required this.label,
    required this.category,
  });

  /// Creates a ChecklistItem instance from a JSON map.
  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'] as int,
      key: json['key'] as String,
      label: json['label'] as String,
      category: json['category'] as String,
    );
  }
}