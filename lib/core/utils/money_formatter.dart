import 'package:intl/intl.dart';

class Formatter {
  static String currency(num amount) {
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    ).format(amount);
  }

  static String number(num value) {
    return NumberFormat.decimalPattern('vi_VN').format(value);
  }
}
