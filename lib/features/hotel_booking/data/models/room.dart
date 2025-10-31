import 'package:tour_guide_app/common/constants/app_default_image.constant.dart';

class Room {
  final String id;
  final String name;
  final String type;
  final int capacity;
  final double pricePerNight;
  final List<String> amenities;
  final String description;
  final bool isAvailable;
  final String image;

  Room({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.pricePerNight,
    required this.amenities,
    required this.description,
    required this.isAvailable,
    required this.image,
  });

  // Mock data
  static List<Room> getMockRooms() {
    return [
      Room(
        id: '1',
        name: 'Phòng Superior',
        type: 'Superior',
        capacity: 2,
        pricePerNight: 800000,
        amenities: ['WiFi', 'Điều hòa', 'TV', 'Minibar'],
        description: 'Phòng cao cấp với view thành phố',
        isAvailable: true,
        image: AppImage.defaultCar, // Use available image
      ),
      Room(
        id: '2',
        name: 'Phòng Deluxe',
        type: 'Deluxe',
        capacity: 2,
        pricePerNight: 1200000,
        amenities: ['WiFi', 'Điều hòa', 'TV', 'Minibar', 'Bồn tắm'],
        description: 'Phòng sang trọng với không gian rộng rãi',
        isAvailable: true,
        image: AppImage.defaultCar,
      ),
      Room(
        id: '3',
        name: 'Phòng Suite',
        type: 'Suite',
        capacity: 4,
        pricePerNight: 2000000,
        amenities: ['WiFi', 'Điều hòa', 'TV', 'Minibar', 'Bồn tắm', 'Phòng khách'],
        description: 'Suite cao cấp với phòng khách riêng',
        isAvailable: true,
        image: AppImage.defaultCar,
      ),
      Room(
        id: '4',
        name: 'Phòng Family',
        type: 'Family',
        capacity: 4,
        pricePerNight: 1500000,
        amenities: ['WiFi', 'Điều hòa', 'TV', '2 Giường đôi'],
        description: 'Phòng gia đình rộng rãi',
        isAvailable: false,
        image: AppImage.defaultCar,
      ),
    ];
  }
}

