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
  Future<List<OSMPOI>> searchPlaces(String query, {int limit = 20}) async {
    try {
      // Bounding box của Việt Nam (lat, lon)
      // Tây Nam: 8.5, 102.0
      // Đông Bắc: 23.5, 110.0
      final response = await _dio.get(
        _nominatimUrl,
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': limit * 3, // Lấy nhiều hơn để lọc sau
          'addressdetails': 1,
          'countrycodes': 'vn', // Giới hạn chỉ ở Việt Nam
          'viewbox': '102.0,23.5,110.0,8.5', // viewbox format: minlon,maxlat,maxlon,minlat
          'bounded': '0', // Không giới hạn chặt trong viewbox, chỉ ưu tiên
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
        // Giới hạn phạm vi Việt Nam (nới lỏng hơn)
        const vietnamMinLat = 8.0;
        const vietnamMaxLat = 24.0;
        const vietnamMinLon = 101.0;
        const vietnamMaxLon = 111.0;
        
        // Loại bỏ các loại không phù hợp (chỉ những loại rõ ràng không phù hợp)
        const excludedTypes = [
          'post_box', 'telephone', 'waste_basket',
          'street_lamp', 'traffic_signals', 'crossing'
        ];
        
        return data
            .map((item) => OSMPOI.fromNominatimResult(item))
            .where((poi) {
              // Kiểm tra tọa độ hợp lệ và trong phạm vi Việt Nam (nới lỏng)
              if (poi.latitude == null || 
                  poi.longitude == null ||
                  poi.latitude! < vietnamMinLat ||
                  poi.latitude! > vietnamMaxLat ||
                  poi.longitude! < vietnamMinLon ||
                  poi.longitude! > vietnamMaxLon) {
                return false;
              }
              
              // Kiểm tra tên hợp lệ - nới lỏng hơn
              if (poi.name == null || 
                  poi.name!.isEmpty || 
                  poi.name == 'Unnamed Place' ||
                  poi.name!.length < 2) {
                return false;
              }
              
              // Chỉ loại bỏ các tên rõ ràng không phù hợp
              final nameLower = poi.name!.toLowerCase();
              if (RegExp(r'^\d+$').hasMatch(poi.name!) ||
                  (nameLower.contains('km') && nameLower.length < 10) ||
                  (nameLower.startsWith('đường') && nameLower.length < 15) ||
                  (nameLower.startsWith('phố') && nameLower.length < 15) ||
                  (nameLower.startsWith('ngõ') && nameLower.length < 15) ||
                  (nameLower.startsWith('hẻm') && nameLower.length < 15)) {
                return false;
              }
              
              // Kiểm tra type - nới lỏng hơn, chỉ loại bỏ những loại rõ ràng không phù hợp
              final type = poi.type?.toLowerCase() ?? '';
              
              // Chỉ loại bỏ các loại rõ ràng không phù hợp
              if (type.isNotEmpty && excludedTypes.any((excluded) => type.contains(excluded))) {
                return false;
              }
              
              // Chấp nhận tất cả các kết quả có tên hợp lệ và tọa độ trong Việt Nam
              return true;
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
    // Ưu tiên lấy tên từ các field khác nhau - nới lỏng hơn
    String? name;
    
    // Thử lấy từ name field trước (tên chính thức)
    if (result['name'] != null && result['name'].toString().isNotEmpty) {
      final candidateName = result['name'].toString().trim();
      // Chỉ loại bỏ nếu rõ ràng không phù hợp
      if (candidateName.length >= 2 && 
          !RegExp(r'^\d+$').hasMatch(candidateName) &&
          !(candidateName.toLowerCase().contains('km') && candidateName.length < 10)) {
        name = candidateName;
      }
    }
    
    // Nếu không có, thử lấy từ display_name - lấy phần đầu tiên
    if ((name == null || name.isEmpty) && result['display_name'] != null) {
      final displayName = result['display_name'].toString();
      final parts = displayName.split(',');
      
      // Thử lấy phần đầu tiên (thường là tên địa điểm)
      if (parts.isNotEmpty) {
        final firstPart = parts.first.trim();
        // Nới lỏng hơn - chỉ loại bỏ nếu rõ ràng không phù hợp
        if (firstPart.length >= 2 && 
            firstPart.length <= 100 && // Cho phép tên dài hơn
            !RegExp(r'^\d+$').hasMatch(firstPart) &&
            !(firstPart.toLowerCase().startsWith('đường') && firstPart.length < 15) &&
            !(firstPart.toLowerCase().startsWith('phố') && firstPart.length < 15) &&
            !(firstPart.toLowerCase().startsWith('ngõ') && firstPart.length < 15) &&
            !(firstPart.toLowerCase().startsWith('hẻm') && firstPart.length < 15) &&
            !(firstPart.toLowerCase().contains('km') && firstPart.length < 10)) {
          name = firstPart;
        }
      }
    }
    
    // Nếu vẫn không có, thử lấy từ address - ưu tiên các field quan trọng
    if ((name == null || name.isEmpty) && result['address'] != null) {
      final address = result['address'] as Map<String, dynamic>?;
      if (address != null) {
        // Ưu tiên: tourism, amenity, shop, leisure, historic
        final candidateName = address['tourism']?.toString() ??
               address['amenity']?.toString() ??
               address['shop']?.toString() ??
               address['leisure']?.toString() ??
               address['historic']?.toString() ??
               address['name']?.toString();
        
        if (candidateName != null && 
            candidateName.trim().isNotEmpty && 
            candidateName.trim().length >= 2) {
          name = candidateName.trim();
        }
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
               address['shop']?.toString() ??
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

