import 'package:equatable/equatable.dart';

enum VoucherDiscountType { percentage, fixed }

class Voucher extends Equatable {
  final int id;
  final String code;
  final String? description;
  final VoucherDiscountType discountType;
  final double value;
  final double? maxDiscountValue;
  final double? minOrderValue;
  final int usedCount;
  final int maxUsage;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Voucher({
    required this.id,
    required this.code,
    this.description,
    required this.discountType,
    required this.value,
    this.maxDiscountValue,
    this.minOrderValue,
    required this.usedCount,
    required this.maxUsage,
    this.startsAt,
    this.expiresAt,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      id: json['id'],
      code: json['code'],
      description: json['description'],
      discountType: VoucherDiscountType.values.firstWhere(
        (e) => e.toString().split('.').last == json['discountType'],
        orElse: () => VoucherDiscountType.fixed,
      ),
      value: double.parse(json['value'].toString()),
      maxDiscountValue:
          json['maxDiscountValue'] != null
              ? double.parse(json['maxDiscountValue'].toString())
              : null,
      minOrderValue:
          json['minOrderValue'] != null
              ? double.parse(json['minOrderValue'].toString())
              : null,
      usedCount: json['usedCount'] ?? 0,
      maxUsage: json['maxUsage'] ?? 0,
      startsAt:
          json['startsAt'] != null ? DateTime.parse(json['startsAt']) : null,
      expiresAt:
          json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      active: json['active'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'discountType': discountType.toString().split('.').last,
      'value': value,
      'maxDiscountValue': maxDiscountValue,
      'minOrderValue': minOrderValue,
      'usedCount': usedCount,
      'maxUsage': maxUsage,
      'startsAt': startsAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'active': active,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    code,
    description,
    discountType,
    value,
    maxDiscountValue,
    minOrderValue,
    usedCount,
    maxUsage,
    startsAt,
    expiresAt,
    active,
    createdAt,
    updatedAt,
  ];
}
