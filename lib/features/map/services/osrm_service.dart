import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class OSRMService {
  final Dio _dio = Dio();
  // Sử dụng public OSRM server hoặc tự host
  static const String _osrmBaseUrl = 'https://router.project-osrm.org/route/v1';

  /// Lấy route giữa 2 điểm
  Future<OSRMRoute?> getRoute({
    required LatLng start,
    required LatLng end,
    List<LatLng>? waypoints,
    String profile = 'car', // car, foot, bike (OSRM profile names)
  }) async {
    try {
      // Xây dựng coordinates string: lon,lat;lon,lat;...
      final coordinates = <String>[];
      coordinates.add('${start.longitude},${start.latitude}');
      
      if (waypoints != null && waypoints.isNotEmpty) {
        for (final waypoint in waypoints) {
          coordinates.add('${waypoint.longitude},${waypoint.latitude}');
        }
      }
      
      coordinates.add('${end.longitude},${end.latitude}');
      
      final coordinatesString = coordinates.join(';');
      
      // Sử dụng profile trong URL để có route khác nhau cho mỗi transport mode
      final url = '$_osrmBaseUrl/$profile/$coordinatesString';
      
      // Debug: in ra URL để kiểm tra
      print('OSRM Request - Profile: $profile, URL: $url');

      final response = await _dio.get(
        url,
        queryParameters: {
          'overview': 'full',
          'geometries': 'geojson',
          'steps': 'true',
        },
        options: Options(
          headers: {
            'User-Agent': 'TourGuideApp/1.0',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['code'] == 'Ok' && data['routes'] != null && data['routes'].isNotEmpty) {
          final route = OSRMRoute.fromJson(data['routes'][0]);
          // Debug: in ra route details
          print('OSRM Response for $profile - Duration: ${route.duration}s, Distance: ${route.distance}m');
          
          // OSRM public server có thể không hỗ trợ tốt các profile khác "car"
          // Luôn điều chỉnh duration dựa trên profile để đảm bảo kết quả chính xác
          final adjustedRoute = _adjustRouteForProfile(route, profile);
          if (adjustedRoute != null && adjustedRoute.duration != route.duration) {
            print('Adjusted route for $profile - Duration: ${adjustedRoute.duration}s (was ${route.duration}s), Distance: ${adjustedRoute.distance}m');
            return adjustedRoute;
          }
          
          return route;
        } else {
          print('OSRM Response - Code: ${data['code']}, Routes: ${data['routes']}');
        }
      } else {
        print('OSRM Response - Status: ${response.statusCode}');
      }
      
      return null;
    } catch (e) {
      print('Error getting OSRM route: $e');
      return null;
    }
  }

  /// Lấy route với nhiều waypoints
  Future<OSRMRoute?> getRouteWithWaypoints({
    required List<LatLng> waypoints,
    String profile = 'car',
  }) async {
    if (waypoints.length < 2) return null;
    
    final start = waypoints.first;
    final end = waypoints.last;
    final middle = waypoints.length > 2 
        ? waypoints.sublist(1, waypoints.length - 1) 
        : null;
    
    return getRoute(
      start: start,
      end: end,
      waypoints: middle,
      profile: profile,
    );
  }

  /// Điều chỉnh route duration dựa trên profile
  /// OSRM public server có thể không hỗ trợ tốt các profile khác "car"
  /// Nên tính toán lại duration dựa trên tốc độ trung bình cho mỗi profile
  OSRMRoute? _adjustRouteForProfile(OSRMRoute route, String profile) {
    // Tốc độ trung bình (m/s) cho mỗi profile
    const speeds = {
      'car': 13.89,     
      'foot': 1.39,      
      'bike': 9.72,     
    };
    
    final speed = speeds[profile];
    if (speed == null) return route;
    
    // Tính toán duration mới dựa trên distance và speed
    final newDuration = route.distance / speed;
    
    // Luôn điều chỉnh duration để đảm bảo kết quả chính xác cho mỗi profile
    return OSRMRoute(
      distance: route.distance,
      duration: newDuration,
      geometry: route.geometry,
      steps: route.steps,
    );
  }
}

class OSRMRoute {
  final double distance; // meters
  final double duration; // seconds
  final List<LatLng> geometry;
  final List<OSRMRouteStep>? steps;

  OSRMRoute({
    required this.distance,
    required this.duration,
    required this.geometry,
    this.steps,
  });

  factory OSRMRoute.fromJson(Map<String, dynamic> json) {
    final geometryData = json['geometry'];
    List<LatLng> geometry = [];
    
    if (geometryData != null) {
      if (geometryData is Map && geometryData['coordinates'] != null) {
        final coords = geometryData['coordinates'] as List;
        geometry = coords.map((coord) {
          return LatLng(coord[1] as double, coord[0] as double);
        }).toList();
      }
    }

    List<OSRMRouteStep>? steps;
    if (json['legs'] != null) {
      steps = [];
      for (final leg in json['legs']) {
        if (leg['steps'] != null) {
          for (final step in leg['steps']) {
            steps.add(OSRMRouteStep.fromJson(step));
          }
        }
      }
    }

    return OSRMRoute(
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      duration: (json['duration'] as num?)?.toDouble() ?? 0.0,
      geometry: geometry,
      steps: steps,
    );
  }
}

class OSRMRouteStep {
  final double distance;
  final double duration;
  final String? instruction;
  final LatLng? location;

  OSRMRouteStep({
    required this.distance,
    required this.duration,
    this.instruction,
    this.location,
  });

  factory OSRMRouteStep.fromJson(Map<String, dynamic> json) {
    LatLng? location;
    if (json['geometry'] != null && json['geometry']['coordinates'] != null) {
      final coords = json['geometry']['coordinates'][0];
      location = LatLng(coords[1] as double, coords[0] as double);
    }

    return OSRMRouteStep(
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      duration: (json['duration'] as num?)?.toDouble() ?? 0.0,
      instruction: json['maneuver']?['instruction'],
      location: location,
    );
  }
}

