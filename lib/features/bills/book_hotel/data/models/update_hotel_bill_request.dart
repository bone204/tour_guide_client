class UpdateHotelBillRequest {
  final int? id;
  final String? contactName;
  final String? contactPhone;
  final String? notes;
  final String? voucherCode;
  final double? travelPointsUsed;
  final String? paymentMethod;

  UpdateHotelBillRequest({
    this.id,
    this.contactName,
    this.contactPhone,
    this.notes,
    this.voucherCode,
    this.travelPointsUsed,
    this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (contactName != null) data['contactName'] = contactName;
    if (contactPhone != null) data['contactPhone'] = contactPhone;
    if (notes != null) data['notes'] = notes;
    if (voucherCode != null) data['voucherCode'] = voucherCode;
    if (travelPointsUsed != null) data['travelPointsUsed'] = travelPointsUsed;
    if (paymentMethod != null) data['paymentMethod'] = paymentMethod;
    return data;
  }
}
