import 'dart:convert';

class Location {
  final String id;
  final String name;
  final String? parentId;
  final String companyId;
  final double latitude;
  final double longitude;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String typeId;
  final Map<String, dynamic> options;
  final String? langPreference;
  final List<dynamic> hygieneScores;
  final double? averageRating;
  final int ratingCount;

  Location({
    required this.id,
    required this.name,
    this.parentId,
    required this.companyId,
    required this.latitude,
    required this.longitude,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    required this.typeId,
    required this.options,
    this.langPreference,
    required this.hygieneScores,
    this.averageRating,
    required this.ratingCount,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      parentId: json['parent_id']?.toString(),
      companyId: json['company_id'].toString(),
      latitude: (json['latitude'] is String)
          ? double.tryParse(json['latitude']) ?? 0.0
          : (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] is String)
          ? double.tryParse(json['longitude']) ?? 0.0
          : (json['longitude'] ?? 0.0).toDouble(),
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      typeId: json['type_id'].toString(),
      options: json['options'] ?? {},
      langPreference: json['lang_preference'],
      hygieneScores: json['hygiene_scores'] ?? [],
      averageRating: json['averageRating'] != null
          ? (json['averageRating'] is String
          ? double.tryParse(json['averageRating'])
          : (json['averageRating'] as num).toDouble())
          : null,
      ratingCount: json['ratingCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "parent_id": parentId,
      "company_id": companyId,
      "latitude": latitude,
      "longitude": longitude,
      "metadata": metadata,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "type_id": typeId,
      "options": options,
      "lang_preference": langPreference,
      "hygiene_scores": hygieneScores,
      "averageRating": averageRating,
      "ratingCount": ratingCount,
    };
  }

  static List<Location> listFromJson(String jsonStr) {
    final data = json.decode(jsonStr) as List;
    return data.map((item) => Location.fromJson(item)).toList();
  }
}
