class ChatResultItem {
  final String name;
  final String? address;
  final String? description;
  final String type;

  const ChatResultItem({
    required this.name,
    required this.type,
    this.address,
    this.description,
  });

  factory ChatResultItem.fromJson(Map<String, dynamic> json) {
    return ChatResultItem(
      name: json['name'] ?? '',
      type: json['type'] ?? 'destination',
      address: json['address'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'address': address,
      'description': description,
    };
  }
}
