class UpdateRentalBillRequest {
  final String? contactName;
  final String? contactPhone;
  final String? notes;
  final String? paymentMethod;
  final String? voucherCode;
  final int? travelPointsUsed;

  UpdateRentalBillRequest({
    this.contactName,
    this.contactPhone,
    this.notes,
    this.paymentMethod,
    this.voucherCode,
    this.travelPointsUsed,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (contactName != null) data['contactName'] = contactName;
    if (contactPhone != null) data['contactPhone'] = contactPhone;
    if (notes != null) data['notes'] = notes;
    if (paymentMethod != null) data['paymentMethod'] = paymentMethod;
    if (voucherCode != null) data['voucherCode'] = voucherCode;
    if (travelPointsUsed != null) data['travelPointsUsed'] = travelPointsUsed;
    return data;
  }
}
