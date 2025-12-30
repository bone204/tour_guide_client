class ChatResultItem {
  final int? id;
  final String name;
  final String? address;
  final String? description;
  final String type;
  final List<String>? images;
  final List<String>? categories;

  const ChatResultItem({
    required this.name,
    required this.type,
    this.id,
    this.address,
    this.description,
    this.images,
    this.categories,
  });

  factory ChatResultItem.fromJson(Map<String, dynamic> json) {
    return ChatResultItem(
      id: json['id'] as int?,
      name: json['name'] ?? '',
      type: json['type'] ?? 'destination',
      address: json['address'] as String?,
      description: json['description'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
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
    };
  }
}
