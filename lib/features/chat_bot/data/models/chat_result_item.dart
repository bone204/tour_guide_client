class ChatResultItem {
  final int? id;
  final String name;
  final String? address;
  final String? description;
  final String type;
  final List<String>? images;
  final List<String>? categories;
  final double? rating;

  const ChatResultItem({
    required this.name,
    required this.type,
    this.id,
    this.address,
    this.description,
    this.images,
    this.categories,
    this.rating,
  });

  factory ChatResultItem.fromJson(Map<String, dynamic> json) {
    // Handling destination entity fields which might differ from default ChatResultItem fields
    final address =
        json['address'] ?? json['specificAddress'] ?? json['reformAddress'];
    final description =
        json['description'] ??
        json['descriptionViet'] ??
        json['descriptionEng'];
    final images = json['images'] ?? json['photos'];

    return ChatResultItem(
      id: json['id'] as int?,
      name: json['name'] ?? '',
      type: json['type'] ?? 'destination',
      address: address as String?,
      description: description as String?,
      images: (images as List<dynamic>?)?.map((e) => e.toString()).toList(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'address': address,
      'description': description,
      'images': images,
      'categories': categories,
      'rating': rating,
    };
  }
}
