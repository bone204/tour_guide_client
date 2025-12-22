import 'package:tour_guide_app/features/travel_itinerary/data/models/user.dart';

class Contract {
  final int id;
  final User user;

  final String citizenId;
  final String businessType;
  final String businessName;
  final String businessProvince;
  final String businessAddress;
  final String taxCode;

  final String businessRegisterPhoto;
  final String citizenFrontPhoto;
  final String citizenBackPhoto;

  final String notes;

  final String bankName;
  final String bankAccountNumber;
  final String bankAccountName;

  final String fullName;
  final String email;
  final String phoneNumber;

  final bool termsAccepted;
  final String status;
  final String? rejectedReason;
  final String statusUpdatedAt;

  final int totalVehicles;
  final int totalRentalTimes;
  final double averageRating;

  final List<dynamic> vehicles;

  final String createdAt;
  final String updatedAt;

  const Contract({
    required this.id,
    required this.user,
    required this.citizenId,
    required this.businessType,
    required this.businessName,
    required this.businessProvince,
    required this.businessAddress,
    required this.taxCode,
    required this.businessRegisterPhoto,
    required this.citizenFrontPhoto,
    required this.citizenBackPhoto,
    required this.notes,
    required this.bankName,
    required this.bankAccountNumber,
    required this.bankAccountName,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.termsAccepted,
    required this.status,
    required this.rejectedReason,
    required this.statusUpdatedAt,
    required this.totalVehicles,
    required this.totalRentalTimes,
    required this.averageRating,
    required this.vehicles,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'] ?? 0,
      user: User.fromJson(json['user'] ?? {}),

      citizenId: json['citizenId'] ?? '',
      businessType: json['businessType'] ?? '',
      businessName: json['businessName'] ?? '',
      businessProvince: json['businessProvince'] ?? '',
      businessAddress: json['businessAddress'] ?? '',
      taxCode: json['taxCode'] ?? '',

      businessRegisterPhoto: json['businessRegisterPhoto'] ?? '',
      citizenFrontPhoto: json['citizenFrontPhoto'] ?? '',
      citizenBackPhoto: json['citizenBackPhoto'] ?? '',

      notes: json['notes'] ?? '',

      bankName: json['bankName'] ?? '',
      bankAccountNumber: json['bankAccountNumber'] ?? '',
      bankAccountName: json['bankAccountName'] ?? '',

      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',

      termsAccepted: json['termsAccepted'] ?? false,
      status: json['status'] ?? '',
      rejectedReason: json['rejectedReason'],
      statusUpdatedAt: json['statusUpdatedAt'] ?? '',

      totalVehicles: json['totalVehicles'] ?? 0,
      totalRentalTimes: json['totalRentalTimes'] ?? 0,
      averageRating:
          double.tryParse(json['averageRating']?.toString() ?? '0') ?? 0,

      vehicles: json['vehicles'] as List? ?? [],

      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'citizenId': citizenId,
      'businessType': businessType,
      'businessName': businessName,
      'businessProvince': businessProvince,
      'businessAddress': businessAddress,
      'taxCode': taxCode,
      'businessRegisterPhoto': businessRegisterPhoto,
      'citizenFrontPhoto': citizenFrontPhoto,
      'citizenBackPhoto': citizenBackPhoto,
      'notes': notes,
      'bankName': bankName,
      'bankAccountNumber': bankAccountNumber,
      'bankAccountName': bankAccountName,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'termsAccepted': termsAccepted,
      'status': status,
      'rejectedReason': rejectedReason,
      'statusUpdatedAt': statusUpdatedAt,
      'totalVehicles': totalVehicles,
      'totalRentalTimes': totalRentalTimes,
      'averageRating': averageRating,
      'vehicles': vehicles,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Contract copyWith({
    int? id,
    User? user,
    String? citizenId,
    String? businessType,
    String? businessName,
    String? businessProvince,
    String? businessAddress,
    String? taxCode,
    String? businessRegisterPhoto,
    String? citizenFrontPhoto,
    String? citizenBackPhoto,
    String? notes,
    String? bankName,
    String? bankAccountNumber,
    String? bankAccountName,
    String? fullName,
    String? email,
    String? phoneNumber,
    bool? termsAccepted,
    String? status,
    String? rejectedReason,
    String? statusUpdatedAt,
    int? totalVehicles,
    int? totalRentalTimes,
    double? averageRating,
    List<dynamic>? vehicles,
    String? createdAt,
    String? updatedAt,
  }) {
    return Contract(
      id: id ?? this.id,
      user: user ?? this.user,
      citizenId: citizenId ?? this.citizenId,
      businessType: businessType ?? this.businessType,
      businessName: businessName ?? this.businessName,
      businessProvince: businessProvince ?? this.businessProvince,
      businessAddress: businessAddress ?? this.businessAddress,
      taxCode: taxCode ?? this.taxCode,
      businessRegisterPhoto:
          businessRegisterPhoto ?? this.businessRegisterPhoto,
      citizenFrontPhoto: citizenFrontPhoto ?? this.citizenFrontPhoto,
      citizenBackPhoto: citizenBackPhoto ?? this.citizenBackPhoto,
      notes: notes ?? this.notes,
      bankName: bankName ?? this.bankName,
      bankAccountNumber:
          bankAccountNumber ?? this.bankAccountNumber,
      bankAccountName: bankAccountName ?? this.bankAccountName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      status: status ?? this.status,
      rejectedReason: rejectedReason ?? this.rejectedReason,
      statusUpdatedAt: statusUpdatedAt ?? this.statusUpdatedAt,
      totalVehicles: totalVehicles ?? this.totalVehicles,
      totalRentalTimes:
          totalRentalTimes ?? this.totalRentalTimes,
      averageRating: averageRating ?? this.averageRating,
      vehicles: vehicles ?? this.vehicles,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ContractResponse {
  final List<Contract> items;

  ContractResponse({required this.items});

  factory ContractResponse.fromJson(dynamic json) {
    if (json is List) {
      return ContractResponse(
        items:
            json
                .map((e) => Contract.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } else if (json is Map<String, dynamic>) {
      return ContractResponse(
        items:
            (json['items'] as List<dynamic>? ?? [])
                .map((e) => Contract.fromJson(e as Map<String, dynamic>))
                .toList(),
      );
    } else {
      return ContractResponse(items: []);
    }
  }

  Map<String, dynamic> toJson() {
    return {'items': items.map((e) => e.toJson()).toList()};
  }
}
