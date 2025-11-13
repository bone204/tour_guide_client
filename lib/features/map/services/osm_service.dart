import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class OSMService {
  final Dio _dio = Dio();
  static const String _overpassUrl = 'https://overpass-api.de/api/interpreter';
  static const String _nominatimUrl = 'https://nominatim.openstreetmap.org';

  /// Lấy POI từ OpenStreetMap trong một bounding box (giới hạn ở Việt Nam)
  Future<List<OSMPOI>> getPOIsInBounds({
    required double minLat,
    required double minLon,
    required double maxLat,
    required double maxLon,
  }) async {
    // Giới hạn bounding box trong phạm vi Việt Nam
    // Việt Nam: lat 8.5 - 23.5, lon 102.0 - 110.0
    final vietnamMinLat = 8.5;
    final vietnamMaxLat = 23.5;
    final vietnamMinLon = 102.0;
    final vietnamMaxLon = 110.0;
    
    // Clamp bounding box vào phạm vi Việt Nam
    final clampedMinLat = minLat < vietnamMinLat ? vietnamMinLat : minLat;
    final clampedMaxLat = maxLat > vietnamMaxLat ? vietnamMaxLat : maxLat;
    final clampedMinLon = minLon < vietnamMinLon ? vietnamMinLon : minLon;
    final clampedMaxLon = maxLon > vietnamMaxLon ? vietnamMaxLon : maxLon;
    
    // Kiểm tra nếu bounding box nằm ngoài Việt Nam
    if (clampedMinLat > vietnamMaxLat || 
        clampedMaxLat < vietnamMinLat ||
        clampedMinLon > vietnamMaxLon || 
        clampedMaxLon < vietnamMinLon) {
      return []; // Ngoài phạm vi Việt Nam
    }
    try {
      // Overpass QL query để lấy các điểm quan tâm (tourism, amenity, historic, etc.)
      // Sử dụng các giá trị đã clamp để đảm bảo chỉ tìm trong phạm vi Việt Nam
      final query = '''
[out:json][timeout:25];
(
  node["tourism"](${clampedMinLat},${clampedMinLon},${clampedMaxLat},${clampedMaxLon});
  node["amenity"](${clampedMinLat},${clampedMinLon},${clampedMaxLat},${clampedMaxLon});
  node["historic"](${clampedMinLat},${clampedMinLon},${clampedMaxLat},${clampedMaxLon});
  way["tourism"](${clampedMinLat},${clampedMinLon},${clampedMaxLat},${clampedMaxLon});
  way["amenity"](${clampedMinLat},${clampedMinLon},${clampedMaxLat},${clampedMaxLon});
  way["historic"](${clampedMinLat},${clampedMinLon},${clampedMaxLat},${clampedMaxLon});
  relation["tourism"](${clampedMinLat},${clampedMinLon},${clampedMaxLat},${clampedMaxLon});
  relation["amenity"](${clampedMinLat},${clampedMinLon},${clampedMaxLat},${clampedMaxLon});
  relation["historic"](${clampedMinLat},${clampedMinLon},${clampedMaxLat},${clampedMaxLon});
);
out center meta;
''';

      final response = await _dio.post(
        _overpassUrl,
        data: query,
        options: Options(
          headers: {
            'Content-Type': 'text/plain',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final elements = data['elements'] as List?;
        
        if (elements == null) return [];

        return elements
            .map((element) => OSMPOI.fromOverpassElement(element))
            .where((poi) => 
                poi.latitude != null && 
                poi.longitude != null &&
                // Lọc thêm để đảm bảo chỉ lấy POIs trong phạm vi Việt Nam
                poi.latitude! >= vietnamMinLat &&
                poi.latitude! <= vietnamMaxLat &&
                poi.longitude! >= vietnamMinLon &&
                poi.longitude! <= vietnamMaxLon)
            .toList();
      }
      
      return [];
    } catch (e) {
      print('Error fetching OSM POIs: $e');
      return [];
    }
  }

  /// Tìm kiếm địa điểm bằng Nominatim (giới hạn ở Việt Nam)
  Future<List<OSMPOI>> searchPlaces(String query, {int limit = 10}) async {
    try {
      // Bounding box của Việt Nam (lat, lon)
      // Tây Nam: 8.5, 102.0
      // Đông Bắc: 23.5, 110.0
      final response = await _dio.get(
        _nominatimUrl,
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': limit * 2, // Lấy nhiều hơn để lọc sau
          'addressdetails': 1,
          'countrycodes': 'vn', // Giới hạn chỉ ở Việt Nam
          'viewbox': '102.0,23.5,110.0,8.5', // viewbox format: minlon,maxlat,maxlon,minlat
          'bounded': '1', // Chỉ tìm trong viewbox
          'extratags': '1', // Lấy thêm tags để lọc tốt hơn
        },
        options: Options(
          headers: {
            'User-Agent': 'TourGuideApp/1.0',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        // Giới hạn phạm vi Việt Nam
        const vietnamMinLat = 8.5;
        const vietnamMaxLat = 23.5;
        const vietnamMinLon = 102.0;
        const vietnamMaxLon = 110.0;
        
        // Danh sách các loại địa điểm quan trọng cho tour guide
        const importantTypes = [
          'tourism', 'amenity', 'historic', 'leisure', 'shop',
          'restaurant', 'hotel', 'attraction', 'museum', 'temple',
          'park', 'beach', 'monument', 'castle', 'ruins'
        ];
        
        // Loại bỏ các loại không phù hợp
        const excludedTypes = [
          'post_box', 'post_office', 'telephone', 'atm', 'bank',
          'pharmacy', 'hospital', 'clinic', 'school', 'university',
          'parking', 'fuel', 'toilets', 'bench', 'waste_basket',
          'street_lamp', 'traffic_signals', 'crossing', 'bus_stop'
        ];
        
        return data
            .map((item) => OSMPOI.fromNominatimResult(item))
            .where((poi) {
              // Kiểm tra tọa độ hợp lệ và trong phạm vi Việt Nam
              if (poi.latitude == null || 
                  poi.longitude == null ||
                  poi.latitude! < vietnamMinLat ||
                  poi.latitude! > vietnamMaxLat ||
                  poi.longitude! < vietnamMinLon ||
                  poi.longitude! > vietnamMaxLon) {
                return false;
              }
              
              // Kiểm tra tên hợp lệ
              if (poi.name == null || 
                  poi.name!.isEmpty || 
                  poi.name == 'Unnamed Place' ||
                  poi.name!.length < 2) {
                return false;
              }
              
              // Loại bỏ các tên chỉ là số hoặc địa chỉ
              if (RegExp(r'^\d+$').hasMatch(poi.name!) ||
                  poi.name!.contains('km') ||
                  poi.name!.startsWith('Đường') ||
                  poi.name!.startsWith('Phố') ||
                  poi.name!.startsWith('Ngõ') ||
                  poi.name!.startsWith('Hẻm')) {
                return false;
              }
              
              // Kiểm tra type
              final type = poi.type?.toLowerCase() ?? '';
              if (type.isEmpty) return false;
              
              // Loại bỏ các loại không phù hợp
              if (excludedTypes.any((excluded) => type.contains(excluded))) {
                return false;
              }
              
              // Ưu tiên các loại quan trọng
              final isImportant = importantTypes.any((important) => 
                type.contains(important) || 
                poi.tags?.keys.any((key) => key.contains(important)) == true
              );
              
              return isImportant || type == 'place';
            })
            .take(limit) // Giới hạn số lượng kết quả
            .toList();
      }
      
      return [];
    } catch (e) {
      print('Error searching OSM places: $e');
      return [];
    }
  }
}

class OSMPOI {
  final String? id;
  final String? name;
  final double? latitude;
  final double? longitude;
  final String? type;
  final Map<String, dynamic>? tags;

  OSMPOI({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.type,
    this.tags,
  });

  factory OSMPOI.fromOverpassElement(Map<String, dynamic> element) {
    final tags = element['tags'] as Map<String, dynamic>? ?? {};
    final lat = element['lat'] ?? element['center']?['lat'];
    final lon = element['lon'] ?? element['center']?['lon'];
    
    return OSMPOI(
      id: 'osm_${element['id']}',
      name: tags['name'] ?? tags['name:vi'] ?? 'Unnamed Place',
      latitude: lat != null ? (lat as num).toDouble() : null,
      longitude: lon != null ? (lon as num).toDouble() : null,
      type: tags['tourism'] ?? tags['amenity'] ?? tags['historic'] ?? 'place',
      tags: tags,
    );
  }

  factory OSMPOI.fromNominatimResult(Map<String, dynamic> result) {
    // Ưu tiên lấy tên từ các field khác nhau
    String? name;
    
    // Thử lấy từ name field trước (tên chính thức)
    if (result['name'] != null && result['name'].toString().isNotEmpty) {
      final candidateName = result['name'].toString().trim();
      // Chỉ lấy nếu không phải là số hoặc địa chỉ
      if (candidateName.length >= 2 && 
          !RegExp(r'^\d+$').hasMatch(candidateName) &&
          !candidateName.contains('km')) {
        name = candidateName;
      }
    }
    
    // Nếu không có, thử lấy từ display_name nhưng lọc kỹ hơn
    if ((name == null || name.isEmpty) && result['display_name'] != null) {
      final displayName = result['display_name'].toString();
      final parts = displayName.split(',');
      
      // Thử lấy phần đầu tiên
      if (parts.isNotEmpty) {
        final firstPart = parts.first.trim();
        // Chỉ lấy nếu có vẻ là tên địa điểm (không phải số, không quá dài)
        if (firstPart.length >= 2 && 
            firstPart.length <= 50 &&
            !RegExp(r'^\d+$').hasMatch(firstPart) &&
            !firstPart.startsWith('Đường') &&
            !firstPart.startsWith('Phố') &&
            !firstPart.startsWith('Ngõ') &&
            !firstPart.startsWith('Hẻm') &&
            !firstPart.contains('km')) {
          name = firstPart;
        }
      }
    }
    
    // Nếu vẫn không có, thử lấy từ address nhưng chỉ các field quan trọng
    if ((name == null || name.isEmpty) && result['address'] != null) {
      final address = result['address'] as Map<String, dynamic>?;
      if (address != null) {
        // Ưu tiên: tourism, amenity name, poi name
        name = address['tourism']?.toString() ??
               address['amenity']?.toString() ??
               address['name']?.toString();
        
        // Nếu vẫn không có, bỏ qua (không lấy house_number hay road)
      }
    }
    
    // Lấy type từ result
    String? type = result['type']?.toString() ?? result['class']?.toString();
    
    // Nếu type là 'place', thử lấy từ address
    if ((type == null || type == 'place') && result['address'] != null) {
      final address = result['address'] as Map<String, dynamic>?;
      if (address != null) {
        type = address['tourism']?.toString() ??
               address['amenity']?.toString() ??
               address['leisure']?.toString() ??
               address['historic']?.toString() ??
               'place';
      }
    }
    
    return OSMPOI(
      id: 'osm_${result['osm_id'] ?? result['place_id'] ?? ''}',
      name: name, // Có thể null, sẽ được lọc ở bước sau
      latitude: double.tryParse(result['lat']?.toString() ?? ''),
      longitude: double.tryParse(result['lon']?.toString() ?? ''),
      type: type ?? 'place',
      tags: result['address'] as Map<String, dynamic>?,
    );
  }

  LatLng? get position {
    if (latitude != null && longitude != null) {
      return LatLng(latitude!, longitude!);
    }
    return null;
  }
}

