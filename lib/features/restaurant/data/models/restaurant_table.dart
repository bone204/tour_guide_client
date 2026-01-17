class RestaurantTable {
  final int id;
  final String name;
  final int guests;
  final String? status;
  final int? priceRange;
  final String? description;
  final String? dishType;

  const RestaurantTable({
    required this.id,
    required this.name,
    required this.guests,
    this.status,
    this.priceRange,
    this.description,
    this.dishType,
  });

  factory RestaurantTable.fromJson(Map<String, dynamic> json) {
    return RestaurantTable(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      guests: int.tryParse(json['guests'].toString()) ?? 0,
      status: json['status'],
      priceRange:
          json['priceRange'] != null
              ? int.tryParse(json['priceRange'].toString())
              : null,
      description: json['description'],
      dishType: json['dishType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'guests': guests,
      'status': status,
      'priceRange': priceRange,
      'description': description,
      'dishType': dishType,
    };
  }
}
