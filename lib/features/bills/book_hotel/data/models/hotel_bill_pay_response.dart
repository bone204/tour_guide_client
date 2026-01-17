class HotelBillPayResponse {
  final String payUrl;
  final int paymentId;

  HotelBillPayResponse({required this.payUrl, required this.paymentId});

  factory HotelBillPayResponse.fromJson(Map<String, dynamic> json) {
    return HotelBillPayResponse(
      payUrl: json['payUrl'] ?? '',
      paymentId:
          json['paymentId'] is int
              ? json['paymentId']
              : int.tryParse(json['paymentId']?.toString() ?? '0') ?? 0,
    );
  }
}
