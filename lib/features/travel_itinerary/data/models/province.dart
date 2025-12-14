class Province {
  final int id;
  final String code;
  final String name;
  final String? region;
  final String? description;
  final String? imageUrl;
  final bool active;
  final String? createdAt;
  final String? updatedAt;

  Province({
    required this.id,
    required this.code,
    required this.name,
    this.region,
    this.description,
    this.imageUrl,
    required this.active,
    this.createdAt,
    this.updatedAt,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      region: json['region'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      active: json['active'] ?? true,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'region': region,
      'description': description,
      'imageUrl': imageUrl,
      'active': active,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Province copyWith({
    int? id,
    String? code,
    String? name,
    String? region,
    String? description,
    String? imageUrl,
    bool? active,
    String? createdAt,
    String? updatedAt,
  }) {
    return Province(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      region: region ?? this.region,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ProvinceResponse {
  final List<Province> items;

  ProvinceResponse({required this.items});

  factory ProvinceResponse.fromJson(dynamic json) {
    if (json is List) {
      return ProvinceResponse(
        items:
            json
                .map((e) => Province.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } else if (json is Map<String, dynamic>) {
      return ProvinceResponse(
        items:
            (json['items'] as List<dynamic>? ?? [])
                .map((e) => Province.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } else {
      return ProvinceResponse(items: []);
    }
  }

  Map<String, dynamic> toJson() {
    return {'items': items.map((e) => e.toJson()).toList()};
  }
}
