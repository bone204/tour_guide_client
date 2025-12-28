class ConfirmQrPaymentRequest {
  final int? paymentId;
  final int rentalId;
  final double? amount;

  ConfirmQrPaymentRequest({
    this.paymentId,
    required this.rentalId,
    this.amount,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (paymentId != null) data['paymentId'] = paymentId;
    data['rentalId'] = rentalId;
    if (amount != null) data['amount'] = amount;
    return data;
  }
}
