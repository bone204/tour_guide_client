class PayVisaRequest {
  final int rentalId;
  final double amount;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;

  PayVisaRequest({
    required this.rentalId,
    required this.amount,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
  });

  Map<String, dynamic> toJson() {
    return {
      'rentalId': rentalId,
      'amount': amount,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
    };
  }
}
