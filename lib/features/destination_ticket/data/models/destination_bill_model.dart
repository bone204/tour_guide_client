import 'package:tour_guide_app/features/destination/data/models/destination.dart';

enum DestinationBillStatus { pending, paid, cancelled, completed }

class DestinationBillModel {
  final int id;
  final String code;
  final int userId;
  final int destinationId;
  final int ticketQuantity;
  final double pricePerTicket;
  final double totalAmount;
  final DestinationBillStatus status;
  final String? paymentMethod;
  final String? contactName;
  final String? contactPhone;
  final String? contactEmail;
  final String? visitDate;
  final DateTime createdAt;
  final Destination? destination;

  DestinationBillModel({
    required this.id,
    required this.code,
    required this.userId,
    required this.destinationId,
    required this.ticketQuantity,
    required this.pricePerTicket,
    required this.totalAmount,
    required this.status,
    this.paymentMethod,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
    this.visitDate,
    required this.createdAt,
    this.destination,
  });

  factory DestinationBillModel.fromJson(Map<String, dynamic> json) {
    return DestinationBillModel(
      id: json['id'],
      code: json['code'],
      userId: json['userId'],
      destinationId: json['destinationId'],
      ticketQuantity: json['ticketQuantity'],
      pricePerTicket: double.tryParse(json['pricePerTicket'].toString()) ?? 0,
      totalAmount: double.tryParse(json['totalAmount'].toString()) ?? 0,
      status: _parseStatus(json['status']),
      paymentMethod: json['paymentMethod'],
      contactName: json['contactName'],
      contactPhone: json['contactPhone'],
      contactEmail: json['contactEmail'],
      visitDate: json['visitDate'],
      createdAt: DateTime.parse(json['createdAt']),
      destination: json['destination'] != null
          ? Destination.fromJson(json['destination'])
          : null,
    );
  }

  static DestinationBillStatus _parseStatus(String status) {
    switch (status) {
      case 'paid':
        return DestinationBillStatus.paid;
      case 'cancelled':
        return DestinationBillStatus.cancelled;
      case 'completed':
        return DestinationBillStatus.completed;
      default:
        return DestinationBillStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'userId': userId,
      'destinationId': destinationId,
      'ticketQuantity': ticketQuantity,
      'pricePerTicket': pricePerTicket,
      'totalAmount': totalAmount,
      'status': status.name,
      'paymentMethod': paymentMethod,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'contactEmail': contactEmail,
      'visitDate': visitDate,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
