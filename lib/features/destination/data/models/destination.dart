class Destination {
  final int id;
  final String name;
  final String? externalId;
  final String? type;
  final String? descriptionViet;
  final String? descriptionEng;
  final String? province;
  final String? specificAddress;
  final double? latitude;
  final double? longitude;
  final double? rating;
  final int? favouriteTimes;
  final int? userRatingsTotal;
  final List<String>? categories;
  final List<String>? photos;
  final List<String>? videos;
  final String? googlePlaceId;
  final String? sourceCreatedAt;
  final bool? available;
  final String? createdAt;
  final String? updatedAt;
  final bool isFromDatabase; // true nếu từ DB, false nếu từ OSM

  const Destination({ 
    required this.id,
    required this.name,
    this.externalId,
    this.type,
    this.descriptionViet,
    this.descriptionEng,
    this.province,
    this.specificAddress,
    this.latitude,
    this.longitude,
    this.rating,
    this.favouriteTimes,
    this.userRatingsTotal,
    this.categories,
    this.photos,
    this.videos,
    this.googlePlaceId,
    this.sourceCreatedAt,
    this.available,
    this.createdAt,
    this.updatedAt,
    this.isFromDatabase = true, // Mặc định là từ database
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      externalId: json['externalId'],
      type: json['type'],
      descriptionViet: json['descriptionViet'],
      descriptionEng: json['descriptionEng'],
      province: json['province'],
      specificAddress: json['specificAddress'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      favouriteTimes: json['favouriteTimes'],
      userRatingsTotal: json['userRatingsTotal'],
      categories: (json['categories'] as List?)?.map((e) => e.toString()).toList(),
      photos: (json['photos'] as List?)?.map((e) => e.toString()).toList(),
      videos: (json['videos'] as List?)?.map((e) => e.toString()).toList(),
      googlePlaceId: json['googlePlaceId'],
      sourceCreatedAt: json['sourceCreatedAt'],
      available: json['available'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isFromDatabase: json['isFromDatabase'] ?? true,
    );
  }

  /// Tạo Destination từ OSM POI
  factory Destination.fromOSMPOI(String id, String name, double lat, double lon, String? type) {
    return Destination(
      id: id.hashCode, // Dùng hash code của OSM ID
      name: name,
      latitude: lat,
      longitude: lon,
      type: type,
      isFromDatabase: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'externalId': externalId,
      'type': type,
      'descriptionViet': descriptionViet,
      'descriptionEng': descriptionEng,
      'province': province,
      'specificAddress': specificAddress,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'favouriteTimes': favouriteTimes,
      'userRatingsTotal': userRatingsTotal,
      'categories': categories,
      'photos': photos,
      'videos': videos,
      'googlePlaceId': googlePlaceId,
      'sourceCreatedAt': sourceCreatedAt,
      'available': available,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isFromDatabase': isFromDatabase,
    };
  }

  Destination copyWith({
    int? id,
    String? name,
    String? externalId,
    String? type,
    String? descriptionViet,
    String? descriptionEng,
    String? province,
    String? specificAddress,
    double? latitude,
    double? longitude,
    double? rating,
    int? favouriteTimes,
    int? userRatingsTotal,
    List<String>? categories,
    List<String>? photos,
    List<String>? videos,
    String? googlePlaceId,
    String? sourceCreatedAt,
    bool? available,
    String? createdAt,
    String? updatedAt,
    bool? isFromDatabase,
  }) {
    return Destination(
      id: id ?? this.id,
      name: name ?? this.name,
      externalId: externalId ?? this.externalId,
      type: type ?? this.type,
      descriptionViet: descriptionViet ?? this.descriptionViet,
      descriptionEng: descriptionEng ?? this.descriptionEng,
      province: province ?? this.province,
      specificAddress: specificAddress ?? this.specificAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      favouriteTimes: favouriteTimes ?? this.favouriteTimes,
      userRatingsTotal: userRatingsTotal ?? this.userRatingsTotal,
      categories: categories ?? this.categories,
      photos: photos ?? this.photos,
      videos: videos ?? this.videos,
      googlePlaceId: googlePlaceId ?? this.googlePlaceId,
      sourceCreatedAt: sourceCreatedAt ?? this.sourceCreatedAt,
      available: available ?? this.available,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFromDatabase: isFromDatabase ?? this.isFromDatabase,
    );
  }
}
