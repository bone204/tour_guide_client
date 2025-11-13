import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class OSRMService {
  final Dio _dio = Dio();
  // Sử dụng public OSRM server hoặc tự host
  static const String _osrmUrl = 'https://router.project-osrm.org/route/v1/driving';

  /// Lấy route giữa 2 điểm
  Future<OSRMRoute?> getRoute({
    required LatLng start,
    required LatLng end,
    List<LatLng>? waypoints,
    String profile = 'driving', // driving, walking, cycling
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

      final response = await _dio.get(
        '$_osrmUrl/$coordinatesString',
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
          return OSRMRoute.fromJson(data['routes'][0]);
        }
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
    String profile = 'driving',
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

