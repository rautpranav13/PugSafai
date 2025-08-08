// lib/models/location.dart
class Location {
  final String id;
  final String name;
  final String? parentId;
  final double? latitude;
  final double? longitude;
  final double? averageRating;
  final int? ratingCount;

  Location({
    required this.id,
    required this.name,
    this.parentId,
    this.latitude,
    this.longitude,
    this.averageRating,
    this.ratingCount,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      parentId: json['parent_id']?.toString(),
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      averageRating: json['averageRating'] != null
          ? double.tryParse(json['averageRating'].toString())
          : null,
      ratingCount: json['ratingCount'] != null
          ? int.tryParse(json['ratingCount'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parent_id': parentId,
      'latitude': latitude,
      'longitude': longitude,
      'averageRating': averageRating,
      'ratingCount': ratingCount,
    };
  }
}
