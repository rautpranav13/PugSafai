class CleanerReview {
  final String id;
  final String name;
  final String phone;
  final String siteId;
  final String userId;
  final List<int> taskIds;
  final String remarks;
  final double latitude;
  final double longitude;
  final String address;
  final List<String> images;
  final DateTime createdAt;

  const CleanerReview({
    required this.id,
    required this.name,
    required this.phone,
    required this.siteId,
    required this.userId,
    required this.taskIds,
    required this.remarks,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.images,
    required this.createdAt,
  });

  /// Creates a CleanerReview instance from a JSON map.
  factory CleanerReview.fromJson(Map<String, dynamic> json) {
    return CleanerReview(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      siteId: json['site_id'] as String,
      userId: json['user_id'] as String,
      // Converts the list of dynamic to a list of integers
      taskIds: List<int>.from(json['task_ids'] as List),
      remarks: json['remarks'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      // Converts the list of dynamic to a list of strings
      images: List<String>.from(json['images'] as List),
      // Parses the date string into a DateTime object
      createdAt: DateTime.parse(json['created at'] as String),
    );
  }
}