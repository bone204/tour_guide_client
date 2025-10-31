class ShippingProvider {
  final String id;
  final String name;
  final String logo;
  final List<VehicleType> vehicleTypes;

  ShippingProvider({
    required this.id,
    required this.name,
    required this.logo,
    required this.vehicleTypes,
  });

  // Mock data for demo
  static List<ShippingProvider> getMockProviders() {
    return [
      ShippingProvider(
        id: '1',
        name: 'Giao Hàng Nhanh',
        logo: '🚚',
        vehicleTypes: VehicleType.getMockVehicles(),
      ),
      ShippingProvider(
        id: '2',
        name: 'Viettel Post',
        logo: '📦',
        vehicleTypes: VehicleType.getMockVehicles(),
      ),
      ShippingProvider(
        id: '3',
        name: 'Grab Express',
        logo: '🏍️',
        vehicleTypes: VehicleType.getMockVehicles(),
      ),
      ShippingProvider(
        id: '4',
        name: 'Ahamove',
        logo: '🚛',
        vehicleTypes: VehicleType.getMockVehicles(),
      ),
    ];
  }
}

class VehicleType {
  final String id;
  final String name;
  final String icon;
  final double basePrice;
  final String description;

  VehicleType({
    required this.id,
    required this.name,
    required this.icon,
    required this.basePrice,
    required this.description,
  });

  // Mock data for demo
  static List<VehicleType> getMockVehicles() {
    return [
      VehicleType(
        id: '1',
        name: 'Xe máy',
        icon: '🏍️',
        basePrice: 25000,
        description: 'Phù hợp cho hàng nhỏ',
      ),
      VehicleType(
        id: '2',
        name: 'Xe ba gác',
        icon: '🛺',
        basePrice: 50000,
        description: 'Phù hợp cho hàng vừa',
      ),
      VehicleType(
        id: '3',
        name: 'Xe tải nhỏ',
        icon: '🚚',
        basePrice: 100000,
        description: 'Phù hợp cho hàng lớn',
      ),
      VehicleType(
        id: '4',
        name: 'Xe tải lớn',
        icon: '🚛',
        basePrice: 200000,
        description: 'Phù hợp cho hàng cồng kềnh',
      ),
    ];
  }
}

