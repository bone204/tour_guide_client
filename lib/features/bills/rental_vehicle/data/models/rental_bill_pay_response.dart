class RentalBillPayResponse {
  final String payUrl;
  final int paymentId;

  RentalBillPayResponse({required this.payUrl, required this.paymentId});

  factory RentalBillPayResponse.fromJson(Map<String, dynamic> json) {
    return RentalBillPayResponse(
      payUrl: json['payUrl'] ?? '',
      paymentId:
          json['paymentId'] is int
              ? json['paymentId']
              : int.tryParse(json['paymentId']?.toString() ?? '0') ?? 0,
    );
  }
}
