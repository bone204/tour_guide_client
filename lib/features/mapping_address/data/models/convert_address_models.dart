class ConvertAddressDto {
  final String address;

  ConvertAddressDto({required this.address});

  Map<String, dynamic> toJson() {
    return {'address': address};
  }
}

class ConvertOldToNewAddressResponse {
  final String newAddress;

  ConvertOldToNewAddressResponse({required this.newAddress});

  factory ConvertOldToNewAddressResponse.fromJson(Map<String, dynamic> json) {
    return ConvertOldToNewAddressResponse(newAddress: json['newAddress'] ?? '');
  }
}

class ConvertNewToOldAddressResponse {
  final List<String> oldAddresses;

  ConvertNewToOldAddressResponse({required this.oldAddresses});

  factory ConvertNewToOldAddressResponse.fromJson(Map<String, dynamic> json) {
    return ConvertNewToOldAddressResponse(
      oldAddresses:
          (json['oldAddresses'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
