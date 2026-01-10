import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';

enum MapType { normal, satellite, terrain }

extension MapTypeExtension on MapType {
  String get urlTemplate {
    switch (this) {
      case MapType.normal:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      case MapType.satellite:
        // Esri World Imagery (Satellite)
        return 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
      case MapType.terrain:
        // OpenTopoMap
        return 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png';
    }
  }

  IconData get icon {
    switch (this) {
      case MapType.normal:
        return Icons.map_outlined;
      case MapType.satellite:
        return Icons.satellite_alt_outlined;
      case MapType.terrain:
        return Icons.terrain_outlined;
    }
  }

  String getLabel(BuildContext context) {
    switch (this) {
      case MapType.normal:
        return AppLocalizations.of(context)!.mapTypeNormal;
      case MapType.satellite:
        return AppLocalizations.of(context)!.mapTypeSatellite;
      case MapType.terrain:
        return AppLocalizations.of(context)!.mapTypeTerrain;
    }
  }
}
