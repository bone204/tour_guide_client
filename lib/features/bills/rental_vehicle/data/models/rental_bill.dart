import 'package:intl/intl.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';
import 'package:tour_guide_app/features/profile/data/models/user.dart';

enum RentalBillStatus {
  pending,
  confirmed,
  paidPendingDelivery,
  paid,
  cancelled,
  completed,
}

enum RentalBillType { hourly, daily }

enum PaymentMethod { momo, qrCode }

enum RentalProgressStatus {
  pending,
  booked,
  delivering,
  delivered,
  inProgress, // in_progress
  returnRequested, // return_requested
  returnConfirmed, // return_confirmed
  cancelled,
}

enum RentalVehicleType { bike, motorcycle, car, truck }

enum RentalBillCancelledBy { user, owner }

class RentalBillDetail {
  final int id;
  final int billId;
  final String licensePlate;
  final double price;
  final String? note;
  final RentalVehicle? vehicle;

  RentalBillDetail({
    required this.id,
    required this.billId,
    required this.licensePlate,
    required this.price,
    this.note,
    this.vehicle,
  });

  factory RentalBillDetail.fromJson(Map<String, dynamic> json) {
    return RentalBillDetail(
      id:
          json['id'] is int
              ? json['id']
              : int.tryParse(json['id'].toString()) ?? 0,
      billId:
          json['billId'] is int
              ? json['billId']
              : int.tryParse(json['billId'].toString()) ?? 0,
      licensePlate: json['licensePlate'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      note: json['note'],
      vehicle:
          json['vehicle'] != null
              ? RentalVehicle.fromJson(json['vehicle'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'billId': billId,
      'licensePlate': licensePlate,
      'price': price,
      'note': note,
      'vehicle': vehicle?.toJson(),
    };
  }
}

class RentalBill {
  final int id;
  final String code;
  final int userId;
  final User? user;
  final RentalBillType rentalType;
  final DateTime startDate;
  final DateTime endDate;
  final String? location;
  final String? durationPackage;
  final PaymentMethod? paymentMethod;
  final String? contactName;
  final String? contactPhone;
  final double total;
  final double ownerTotal; // Added per request
  final int? voucherId;
  final int travelPointsUsed;
  final RentalBillStatus status;
  final String? notes;
  final String? cancelReason;
  final RentalProgressStatus rentalStatus;
  final List<RentalBillDetail> details;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional fields for workflow
  final List<String> deliveryPhotos;
  final String? pickupSelfiePhoto;
  final List<String> returnPhotosUser;
  final List<String> returnPhotosOwner;
  final double? pickupLatitude;
  final double? pickupLongitude;

  // New fields from server sync
  final RentalVehicleType vehicleType;
  final bool requiresEthDeposit;
  final String? ownerEthAddress;
  final String? verifiedSelfiePhoto;
  final RentalBillCancelledBy? cancelledBy;
  final DateTime? returnTimestampUser;
  final double? returnLatitudeUser;
  final double? returnLongitudeUser;
  final double? returnLatitudeOwner;
  final double? returnLongitudeOwner;
  final double? deliveryLatitudeOwner;
  final double? deliveryLongitudeOwner;
  final DateTime? deliveryDate;
  final DateTime? returnDate;
  final double overtimeFee;
  final double shippingFee;
  final bool isShippingFeeNegotiable;
  final String? guestToken;
  final DateTime? guestTokenExpiresAt;

  RentalBill({
    required this.id,
    required this.code,
    required this.userId,
    this.user,
    required this.rentalType,
    required this.startDate,
    required this.endDate,
    this.location,
    this.durationPackage,
    this.paymentMethod,
    this.contactName,
    this.contactPhone,
    required this.total,
    required this.ownerTotal,
    this.voucherId,
    required this.travelPointsUsed,
    required this.status,
    this.notes,
    this.cancelReason,
    required this.rentalStatus,
    required this.details,
    required this.createdAt,
    required this.updatedAt,
    this.deliveryPhotos = const [],
    this.pickupSelfiePhoto,
    this.returnPhotosUser = const [],
    this.returnPhotosOwner = const [],
    this.pickupLatitude,
    this.pickupLongitude,
    required this.vehicleType,
    required this.requiresEthDeposit,
    this.ownerEthAddress,
    this.verifiedSelfiePhoto,
    this.cancelledBy,
    this.returnTimestampUser,
    this.returnLatitudeUser,
    this.returnLongitudeUser,
    this.returnLatitudeOwner,
    this.returnLongitudeOwner,
    this.deliveryLatitudeOwner,
    this.deliveryLongitudeOwner,
    this.deliveryDate,
    this.returnDate,
    required this.overtimeFee,
    required this.shippingFee,
    required this.isShippingFeeNegotiable,
    this.guestToken,
    this.guestTokenExpiresAt,
  });

  factory RentalBill.fromJson(Map<String, dynamic> json) {
    return RentalBill(
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
      rentalType: _parseRentalType(json['rentalType']),
      startDate: _parseDate(json['startDate']),
      endDate: _parseDate(json['endDate']),
      location: json['location'],
      durationPackage: json['durationPackage'],
      paymentMethod: _parsePaymentMethod(json['paymentMethod']),
      contactName: json['contactName'],
      contactPhone: json['contactPhone'],
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0,
      ownerTotal: double.tryParse(json['ownerTotal']?.toString() ?? '0') ?? 0,
      voucherId:
          json['voucherId'] is int
              ? json['voucherId']
              : int.tryParse(json['voucherId']?.toString() ?? ''),
      travelPointsUsed:
          json['travelPointsUsed'] is int
              ? json['travelPointsUsed']
              : int.tryParse(json['travelPointsUsed']?.toString() ?? '0') ?? 0,
      status: _parseStatus(json['status']),
      notes: json['notes'],
      cancelReason: json['cancelReason'],
      rentalStatus: _parseRentalStatus(json['rentalStatus']),
      details:
          (json['details'] as List<dynamic>?)
              ?.map((e) => RentalBillDetail.fromJson(e))
              .toList() ??
          [],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      deliveryPhotos:
          (json['deliveryPhotos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      pickupSelfiePhoto: json['pickupSelfiePhoto'],
      returnPhotosUser:
          (json['returnPhotosUser'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      returnPhotosOwner:
          (json['returnPhotosOwner'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      pickupLatitude: double.tryParse(json['pickupLatitude']?.toString() ?? ''),
      pickupLongitude: double.tryParse(
        json['pickupLongitude']?.toString() ?? '',
      ),

      // New fields parsing
      vehicleType: _parseVehicleType(json['vehicleType']),
      requiresEthDeposit: json['requiresEthDeposit'] ?? false,
      ownerEthAddress: json['ownerEthAddress'],
      verifiedSelfiePhoto: json['verifiedSelfiePhoto'],
      cancelledBy: _parseCancelledBy(json['cancelledBy']),
      returnTimestampUser: DateTime.tryParse(json['returnTimestampUser'] ?? ''),
      returnLatitudeUser: double.tryParse(
        json['returnLatitudeUser']?.toString() ?? '',
      ),
      returnLongitudeUser: double.tryParse(
        json['returnLongitudeUser']?.toString() ?? '',
      ),
      returnLatitudeOwner: double.tryParse(
        json['returnLatitudeOwner']?.toString() ?? '',
      ),
      returnLongitudeOwner: double.tryParse(
        json['returnLongitudeOwner']?.toString() ?? '',
      ),
      deliveryLatitudeOwner: double.tryParse(
        json['deliveryLatitudeOwner']?.toString() ?? '',
      ),
      deliveryLongitudeOwner: double.tryParse(
        json['deliveryLongitudeOwner']?.toString() ?? '',
      ),
      deliveryDate: DateTime.tryParse(json['deliveryDate'] ?? ''),
      returnDate: DateTime.tryParse(json['returnDate'] ?? ''),
      overtimeFee: double.tryParse(json['overtimeFee']?.toString() ?? '0') ?? 0,
      shippingFee: double.tryParse(json['shippingFee']?.toString() ?? '0') ?? 0,
      isShippingFeeNegotiable: json['isShippingFeeNegotiable'] ?? false,
      guestToken: json['guestToken'],
      guestTokenExpiresAt: DateTime.tryParse(json['guestTokenExpiresAt'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'userId': userId,
      'user': user?.toJson(),
      'rentalType': _rentalTypeToString(rentalType),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'location': location,
      'durationPackage': durationPackage,
      'paymentMethod': _paymentMethodToString(paymentMethod),
      'contactName': contactName,
      'contactPhone': contactPhone,
      'total': total,
      'ownerTotal': ownerTotal,
      'voucherId': voucherId,
      'travelPointsUsed': travelPointsUsed,
      'status': _statusToString(status),
      'notes': notes,
      'cancelReason': cancelReason,
      'rentalStatus': _rentalStatusToString(rentalStatus),
      'details': details.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deliveryPhotos': deliveryPhotos,
      'pickupSelfiePhoto': pickupSelfiePhoto,
      'returnPhotosUser': returnPhotosUser,
      'returnPhotosOwner': returnPhotosOwner,
      'pickupLatitude': pickupLatitude,
      'pickupLongitude': pickupLongitude,
      'vehicleType': vehicleType.name,
      'requiresEthDeposit': requiresEthDeposit,
      'ownerEthAddress': ownerEthAddress,
      'verifiedSelfiePhoto': verifiedSelfiePhoto,
      'cancelledBy': cancelledBy?.name,
      'returnTimestampUser': returnTimestampUser?.toIso8601String(),
      'returnLatitudeUser': returnLatitudeUser,
      'returnLongitudeUser': returnLongitudeUser,
      'returnLatitudeOwner': returnLatitudeOwner,
      'returnLongitudeOwner': returnLongitudeOwner,
      'deliveryLatitudeOwner': deliveryLatitudeOwner,
      'deliveryLongitudeOwner': deliveryLongitudeOwner,
      'deliveryDate': deliveryDate?.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
      'overtimeFee': overtimeFee,
      'shippingFee': shippingFee,
      'isShippingFeeNegotiable': isShippingFeeNegotiable,
      'guestToken': guestToken,
      'guestTokenExpiresAt': guestTokenExpiresAt?.toIso8601String(),
    };
  }

  static RentalBillType _parseRentalType(String? value) {
    switch (value) {
      case 'daily':
        return RentalBillType.daily;
      case 'hourly':
        return RentalBillType.hourly;
      default:
        return RentalBillType.daily; // Default or fallback
    }
  }

  static String _rentalTypeToString(RentalBillType type) {
    return type.name;
  }

  static PaymentMethod? _parsePaymentMethod(String? value) {
    switch (value) {
      case 'momo':
        return PaymentMethod.momo;
      case 'qr_code':
        return PaymentMethod.qrCode;
      default:
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
    }
  }

  static RentalBillStatus _parseStatus(String? value) {
    switch (value) {
      case 'pending':
        return RentalBillStatus.pending;
      case 'confirmed':
        return RentalBillStatus.confirmed;
      case 'paid_pending_delivery':
        return RentalBillStatus.paidPendingDelivery;
      case 'paid':
        return RentalBillStatus.paid;
      case 'cancelled':
        return RentalBillStatus.cancelled;
      case 'completed':
        return RentalBillStatus.completed;
      default:
        return RentalBillStatus.pending;
    }
  }

  static String _statusToString(RentalBillStatus status) {
    switch (status) {
      case RentalBillStatus.pending:
        return 'pending';
      case RentalBillStatus.confirmed:
        return 'confirmed';
      case RentalBillStatus.paidPendingDelivery:
        return 'paid_pending_delivery';
      case RentalBillStatus.paid:
        return 'paid';
      case RentalBillStatus.cancelled:
        return 'cancelled';
      case RentalBillStatus.completed:
        return 'completed';
    }
  }

  static RentalProgressStatus _parseRentalStatus(String? value) {
    switch (value) {
      case 'pending':
        return RentalProgressStatus.pending;
      case 'booked':
        return RentalProgressStatus.booked;
      case 'delivering':
        return RentalProgressStatus.delivering;
      case 'delivered':
        return RentalProgressStatus.delivered;
      case 'in_progress':
        return RentalProgressStatus.inProgress;
      case 'return_requested':
        return RentalProgressStatus.returnRequested;
      case 'return_confirmed':
        return RentalProgressStatus.returnConfirmed;
      case 'cancelled':
        return RentalProgressStatus.cancelled;
      default:
        return RentalProgressStatus.pending;
    }
  }

  static String _rentalStatusToString(RentalProgressStatus status) {
    switch (status) {
      case RentalProgressStatus.pending:
        return 'pending';
      case RentalProgressStatus.booked:
        return 'booked';
      case RentalProgressStatus.delivering:
        return 'delivering';
      case RentalProgressStatus.delivered:
        return 'delivered';
      case RentalProgressStatus.inProgress:
        return 'in_progress';
      case RentalProgressStatus.returnRequested:
        return 'return_requested';
      case RentalProgressStatus.returnConfirmed:
        return 'return_confirmed';
      case RentalProgressStatus.cancelled:
        return 'cancelled';
    }
  }

  static DateTime _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return DateTime.now();

    try {
      // First try standard ISO 8601
      return DateTime.parse(dateStr);
    } catch (_) {
      try {
        // Try the custom format from server: dd-MM-yyyy HH:mm:ss
        return DateFormat("dd-MM-yyyy HH:mm:ss").parse(dateStr);
      } catch (e) {
        print("Error parsing date: $dateStr, error: $e");
        return DateTime.now();
      }
    }
  }

  static RentalVehicleType _parseVehicleType(String? value) {
    if (value == null) return RentalVehicleType.bike;
    try {
      return RentalVehicleType.values.firstWhere(
        (e) => e.name == value.toLowerCase(),
      );
    } catch (_) {
      return RentalVehicleType.bike;
    }
  }

  static RentalBillCancelledBy? _parseCancelledBy(String? value) {
    if (value == null) return null;
    try {
      return RentalBillCancelledBy.values.firstWhere(
        (e) => e.name == value.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
