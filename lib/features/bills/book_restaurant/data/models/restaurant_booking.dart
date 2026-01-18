import 'package:tour_guide_app/features/cooperations/data/models/cooperation.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_table.dart';
import 'package:tour_guide_app/features/auth/data/models/user.dart';
import 'package:tour_guide_app/core/utils/date_formatter.dart';

class RestaurantBooking {
  final int? id;
  final String? code;
  final UserModel? user;
  final List<RestaurantTable>? tables;
  final Cooperation? cooperation;
  final DateTime? checkInDate;
  final int? durationMinutes;
  final int? numberOfGuests;
  final String? contactName;
  final String? contactPhone;
  final String? notes;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RestaurantBooking({
    this.id,
    this.code,
    this.user,
    this.tables,
    this.cooperation,
    this.checkInDate,
    this.durationMinutes,
    this.numberOfGuests,
    this.contactName,
    this.contactPhone,
    this.notes,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory RestaurantBooking.fromJson(Map<String, dynamic> json) {
    return RestaurantBooking(
      id: json['id'],
      code: json['code'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      tables:
          json['tables'] != null
              ? (json['tables'] as List)
                  .map((e) => RestaurantTable.fromJson(e))
                  .toList()
              : null,
      cooperation:
          json['cooperation'] != null
              ? Cooperation.fromJson(json['cooperation'])
              : null,
      checkInDate:
          json['checkInDate'] != null ? _parseDate(json['checkInDate']) : null,
      durationMinutes: json['durationMinutes'],
      numberOfGuests: json['numberOfGuests'],
      contactName: json['contactName'],
      contactPhone: json['contactPhone'],
      notes: json['notes'],
      status: json['status'],
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'])
              : null,
    );
  }

  static DateTime? _parseDate(dynamic dateStr) {
    if (dateStr == null) return null;
    if (dateStr is DateTime) return dateStr;
    try {
      return DateFormatter.parse(dateStr.toString());
    } catch (e) {
      return null;
    }
  }
}
