import 'package:intl/intl.dart';
import 'package:tour_guide_app/features/hotel_booking/data/models/room.dart';
import 'package:tour_guide_app/features/profile/data/models/user.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation.dart';

enum HotelBillStatus { pending, confirmed, paid, cancelled, completed }

enum PaymentMethod { momo, qrCode, cash }

class HotelBillDetail {
  final int id;
  final int billId;
  final String roomName;
  final double pricePerNight;
  final double total;
  final HotelRoom? room;

  HotelBillDetail({
    required this.id,
    required this.billId,
    required this.roomName,
    required this.pricePerNight,
    required this.total,
    this.room,
  });

  factory HotelBillDetail.fromJson(Map<String, dynamic> json) {
    return HotelBillDetail(
      id:
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id'].toString()) ?? 0,
      billId:
          json['billId'] is int
              ? json['billId']
              : int.tryParse(json['billId'].toString()) ?? 0,
      roomName: json['roomName'] ?? '',
      pricePerNight:
          double.tryParse(json['pricePerNight']?.toString() ?? '0') ?? 0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0,
      room: json['room'] != null ? HotelRoom.fromJson(json['room']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'billId': billId,
      'roomName': roomName,
      'pricePerNight': pricePerNight,
      'total': total,
      'room': room?.toJson(),
    };
  }
}

class HotelBill {
  final int id;
  final String code;
  final int userId;
  final User? user;
  final int? cooperationId;
  final Cooperation? cooperation;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfRooms;
  final int nights;
  final PaymentMethod? paymentMethod;
  final String? contactName;
  final String? contactPhone;
  final double total;
  final int? voucherId;
  final int travelPointsUsed;
  final HotelBillStatus status;
  final String? notes;
  final List<HotelBillDetail> details;
  final DateTime createdAt;
  final DateTime updatedAt;

  HotelBill({
    required this.id,
    required this.code,
    required this.userId,
    this.user,
    this.cooperationId,
    this.cooperation,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfRooms,
    required this.nights,
    this.paymentMethod,
    this.contactName,
    this.contactPhone,
    required this.total,
    this.voucherId,
    required this.travelPointsUsed,
    required this.status,
    this.notes,
    required this.details,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HotelBill.fromJson(Map<String, dynamic> json) {
    return HotelBill(
      id:
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id'].toString()) ?? 0,
      code: json['code'] ?? '',
      userId:
          json['userId'] is int
              ? json['userId']
              : int.tryParse(json['userId'].toString()) ?? 0,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      cooperationId:
          json['cooperationId'] is int
              ? json['cooperationId']
              : int.tryParse(json['cooperationId']?.toString() ?? ''),
      cooperation:
          json['cooperation'] != null
              ? Cooperation.fromJson(json['cooperation'])
              : null,
      checkInDate: _parseDate(json['checkInDate']),
      checkOutDate: _parseDate(json['checkOutDate']),
      numberOfRooms:
          json['numberOfRooms'] is int
              ? json['numberOfRooms']
              : int.tryParse(json['numberOfRooms']?.toString() ?? '0') ?? 0,
      nights:
          json['nights'] is int
              ? json['nights']
              : int.tryParse(json['nights']?.toString() ?? '0') ?? 0,
      paymentMethod: _parsePaymentMethod(json['paymentMethod']),
      contactName: json['contactName'],
      contactPhone: json['contactPhone'],
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0,
      voucherId:
          json['voucherId'] is int
              ? json['voucherId']
              : int.tryParse(json['voucherId']?.toString() ?? ''),
      travelPointsUsed:
          json['travelPointsUsed'] is int
              ? json['travelPointsUsed']
              : int.tryParse(json['travelPointsUsed']?.toString() ?? '0') ?? 0,
      status: _parseStatus(json['status']),
      details:
          (json['details'] as List<dynamic>?)
              ?.map((e) => HotelBillDetail.fromJson(e))
              .toList() ??
          [],
      notes: json['notes'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'userId': userId,
      'user': user?.toJson(),
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'numberOfRooms': numberOfRooms,
      'nights': nights,
      'paymentMethod': _paymentMethodToString(paymentMethod),
      'contactName': contactName,
      'contactPhone': contactPhone,
      'total': total,
      'voucherId': voucherId,
      'travelPointsUsed': travelPointsUsed,
      'status': _statusToString(status),
      'notes': notes,
      'details': details.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static PaymentMethod? _parsePaymentMethod(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'momo':
        return PaymentMethod.momo;
      case 'qr_code':
      case 'qrcode':
        return PaymentMethod.qrCode;
      case 'cash':
        return PaymentMethod.cash;
      default:
        // Attempt to guess or default if needed, or null
        return null;
    }
  }

  static String? _paymentMethodToString(PaymentMethod? method) {
    if (method == null) return null;
    switch (method) {
      case PaymentMethod.momo:
        return 'momo';
      case PaymentMethod.qrCode:
        return 'qr_code';
      case PaymentMethod.cash:
        return 'cash';
    }
  }

  static HotelBillStatus _parseStatus(String? value) {
    switch (value) {
      case 'pending':
        return HotelBillStatus.pending;
      case 'confirmed':
        return HotelBillStatus.confirmed;
      case 'paid':
        return HotelBillStatus.paid;
      case 'cancelled':
        return HotelBillStatus.cancelled;
      case 'completed':
        return HotelBillStatus.completed;
      default:
        return HotelBillStatus.pending;
    }
  }

  static String _statusToString(HotelBillStatus status) {
    switch (status) {
      case HotelBillStatus.pending:
        return 'pending';
      case HotelBillStatus.confirmed:
        return 'confirmed';
      case HotelBillStatus.paid:
        return 'paid';
      case HotelBillStatus.cancelled:
        return 'cancelled';
      case HotelBillStatus.completed:
        return 'completed';
    }
  }

  static DateTime _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return DateTime.now();

    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      try {
        return DateFormat("dd-MM-yyyy HH:mm:ss").parse(dateStr);
      } catch (e) {
        return DateTime.now();
      }
    }
  }
}
