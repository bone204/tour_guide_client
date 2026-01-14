import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

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
    DateTime? parseDate(dynamic date) {
      if (date == null) return null;
      try {
        return DateFormat('dd-MM-yyyy HH:mm:ss').parse(date.toString());
      } catch (_) {
        return DateTime.tryParse(date.toString());
      }
    }

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
      startsAt: parseDate(json['startsAt']),
      expiresAt: parseDate(json['expiresAt']),
      active: json['active'] ?? false,
      createdAt: parseDate(json['createdAt']) ?? DateTime.now(),
      updatedAt: parseDate(json['updatedAt']) ?? DateTime.now(),
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
