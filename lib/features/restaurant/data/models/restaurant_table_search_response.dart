class RestaurantTableSearchResponse {
  final int id;
  final String name;
  final int quantity;
  final String? dishType;
  final String? priceRange;
  final int? maxPeople;
  final String? photo;
  final String? note;
  final bool active;
  final int availableQuantity;
  final bool isAvailable;

  const RestaurantTableSearchResponse({
    required this.id,
    required this.name,
    required this.quantity,
    this.dishType,
    this.priceRange,
    this.maxPeople,
    this.photo,
    this.note,
    required this.active,
    required this.availableQuantity,
    required this.isAvailable,
  });

  factory RestaurantTableSearchResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantTableSearchResponse(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      dishType: json['dishType'],
      priceRange: json['priceRange'],
      maxPeople: json['maxPeople'],
      photo: json['photo'],
      note: json['note'],
      active: json['active'] ?? true,
      availableQuantity: json['availableQuantity'] ?? 0,
      isAvailable: json['isAvailable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'dishType': dishType,
      'priceRange': priceRange,
      'maxPeople': maxPeople,
      'photo': photo,
      'note': note,
      'active': active,
      'availableQuantity': availableQuantity,
      'isAvailable': isAvailable,
    };
  }
}
