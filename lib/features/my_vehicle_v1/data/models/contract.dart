import 'package:tour_guide_app/features/my_vehicle_v1/data/models/contract_params.dart';
import 'package:tour_guide_app/features/my_vehicle_v1/data/models/vehicle.dart';

enum RentalContractStatus {
  pending,
  approved,
  rejected,
  suspended;

  String get value => name;

  static RentalContractStatus fromString(String? value) {
    if (value == null) {
      return RentalContractStatus.pending;
    }
    final match =
        RentalContractStatus.values
            .where((status) => status.value == value.toLowerCase())
            .toList();
    return match.isNotEmpty ? match.first : RentalContractStatus.pending;
  }
}

class ContractUserSummary {
  final int id;
  final String? fullName;
  final String? email;
  final String? phone;

  const ContractUserSummary({
    required this.id,
    this.fullName,
    this.email,
    this.phone,
  });

  factory ContractUserSummary.fromJson(Map<String, dynamic> json) {
    return ContractUserSummary(
      id:
          json['id'] is int
              ? json['id'] as int
              : int.tryParse('${json['id']}') ?? 0,
      fullName: json['fullName'] as String? ?? json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'fullName': fullName, 'email': email, 'phone': phone};
  }
}

class Contract {
  final int id;
  final int userId;
  final ContractUserSummary? user;
  final String? citizenId;
  final BusinessType businessType;
  final String? businessName;
  final String? businessProvince;
  final String? businessAddress;
  final String? taxCode;
  final String? businessRegisterPhoto;
  final String? citizenFrontPhoto;
  final String? citizenBackPhoto;
  final String? contractTerm;
  final String? notes;
  final String? bankName;
  final String? bankAccountNumber;
  final String? bankAccountName;
  final bool termsAccepted;
  final RentalContractStatus status;
  final String? rejectedReason;
  final DateTime? statusUpdatedAt;
  final int totalVehicles;
  final int totalRentalTimes;
  final double averageRating;
  final List<Vehicle>? vehicles;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Contract({
    required this.id,
    required this.userId,
    this.user,
    this.citizenId,
    this.businessType = BusinessType.personal,
    this.businessName,
    this.businessProvince,
    this.businessAddress,
    this.taxCode,
    this.businessRegisterPhoto,
    this.citizenFrontPhoto,
    this.citizenBackPhoto,
    this.contractTerm,
    this.notes,
    this.bankName,
    this.bankAccountNumber,
    this.bankAccountName,
    required this.termsAccepted,
    this.status = RentalContractStatus.pending,
    this.rejectedReason,
    this.statusUpdatedAt,
    required this.totalVehicles,
    required this.totalRentalTimes,
    required this.averageRating,
    this.vehicles,
    this.createdAt,
    this.updatedAt,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    final vehiclesJson = json['vehicles'];
    return Contract(
      id: _parseInt(json['id']) ?? 0,
      userId: _parseInt(json['userId']) ?? 0,
      user:
          userJson is Map<String, dynamic>
              ? ContractUserSummary.fromJson(userJson)
              : null,
      citizenId: json['citizenId'] as String?,
      businessType: BusinessType.fromString(json['businessType'] as String?),
      businessName: json['businessName'] as String?,
      businessProvince: json['businessProvince'] as String?,
      businessAddress: json['businessAddress'] as String?,
      taxCode: json['taxCode'] as String?,
      businessRegisterPhoto: json['businessRegisterPhoto'] as String?,
      citizenFrontPhoto: json['citizenFrontPhoto'] as String?,
      citizenBackPhoto: json['citizenBackPhoto'] as String?,
      contractTerm: json['contractTerm'] as String?,
      notes: json['notes'] as String?,
      bankName: json['bankName'] as String?,
      bankAccountNumber: json['bankAccountNumber'] as String?,
      bankAccountName: json['bankAccountName'] as String?,
      termsAccepted: json['termsAccepted'] == true,
      status: RentalContractStatus.fromString(json['status'] as String?),
      rejectedReason: json['rejectedReason'] as String?,
      statusUpdatedAt: _parseDate(json['statusUpdatedAt']),
      totalVehicles: _parseInt(json['totalVehicles']) ?? 0,
      totalRentalTimes: _parseInt(json['totalRentalTimes']) ?? 0,
      averageRating: double.tryParse('${json['averageRating'] ?? '0'}') ?? 0,
      vehicles:
          vehiclesJson is List
              ? vehiclesJson
                  .whereType<Map<String, dynamic>>()
                  .map(Vehicle.fromJson)
                  .toList()
              : null,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'user': user?.toJson(),
      'citizenId': citizenId,
      'businessType': businessType.value,
      'businessName': businessName,
      'businessProvince': businessProvince,
      'businessAddress': businessAddress,
      'taxCode': taxCode,
      'businessRegisterPhoto': businessRegisterPhoto,
      'citizenFrontPhoto': citizenFrontPhoto,
      'citizenBackPhoto': citizenBackPhoto,
      'contractTerm': contractTerm,
      'notes': notes,
      'bankName': bankName,
      'bankAccountNumber': bankAccountNumber,
      'bankAccountName': bankAccountName,
      'termsAccepted': termsAccepted,
      'status': status.value,
      'rejectedReason': rejectedReason,
      'statusUpdatedAt': statusUpdatedAt?.toIso8601String(),
      'totalVehicles': totalVehicles,
      'totalRentalTimes': totalRentalTimes,
      'averageRating': averageRating,
      'vehicles': vehicles?.map((vehicle) => vehicle.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
