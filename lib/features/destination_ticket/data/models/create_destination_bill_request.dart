class CreateDestinationBillRequest {
  final int destinationId;
  final int ticketQuantity;
  final String? paymentMethod;
  final String? contactName;
  final String? contactPhone;
  final String? contactEmail;
  final String? visitDate;

  CreateDestinationBillRequest({
    required this.destinationId,
    required this.ticketQuantity,
    this.paymentMethod,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
    this.visitDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'destinationId': destinationId,
      'ticketQuantity': ticketQuantity,
      'paymentMethod': paymentMethod,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'contactEmail': contactEmail,
      'visitDate': visitDate,
    };
  }
}
