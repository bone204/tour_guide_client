class DeliveryOrder {
  final String? senderName;
  final String? senderPhone;
  final String? senderAddress;
  
  final String? receiverName;
  final String? receiverPhone;
  final String? receiverAddress;
  
  final String? shippingProviderId;
  final String? shippingProviderName;
  
  final String? vehicleTypeId;
  final String? vehicleTypeName;
  final double? vehicleBasePrice;
  
  final List<String> packageImages;
  final String? specialRequirements;
  
  final double totalCost;
  final double distance;

  DeliveryOrder({
    this.senderName,
    this.senderPhone,
    this.senderAddress,
    this.receiverName,
    this.receiverPhone,
    this.receiverAddress,
    this.shippingProviderId,
    this.shippingProviderName,
    this.vehicleTypeId,
    this.vehicleTypeName,
    this.vehicleBasePrice,
    this.packageImages = const [],
    this.specialRequirements,
    this.totalCost = 0,
    this.distance = 0,
  });

  DeliveryOrder copyWith({
    String? senderName,
    String? senderPhone,
    String? senderAddress,
    String? receiverName,
    String? receiverPhone,
    String? receiverAddress,
    String? shippingProviderId,
    String? shippingProviderName,
    String? vehicleTypeId,
    String? vehicleTypeName,
    double? vehicleBasePrice,
    List<String>? packageImages,
    String? specialRequirements,
    double? totalCost,
    double? distance,
  }) {
    return DeliveryOrder(
      senderName: senderName ?? this.senderName,
      senderPhone: senderPhone ?? this.senderPhone,
      senderAddress: senderAddress ?? this.senderAddress,
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      receiverAddress: receiverAddress ?? this.receiverAddress,
      shippingProviderId: shippingProviderId ?? this.shippingProviderId,
      shippingProviderName: shippingProviderName ?? this.shippingProviderName,
      vehicleTypeId: vehicleTypeId ?? this.vehicleTypeId,
      vehicleTypeName: vehicleTypeName ?? this.vehicleTypeName,
      vehicleBasePrice: vehicleBasePrice ?? this.vehicleBasePrice,
      packageImages: packageImages ?? this.packageImages,
      specialRequirements: specialRequirements ?? this.specialRequirements,
      totalCost: totalCost ?? this.totalCost,
      distance: distance ?? this.distance,
    );
  }
}

