import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDateRange(String start, String end) {
    if (start.isEmpty || end.isEmpty) return '';
    try {
      final startDate = parse(start);
      final endDate = parse(end);
      final formatter = DateFormat('dd/MM/yyyy');
      final startStr = formatter.format(startDate);
      final endStr = formatter.format(endDate);
      if (startStr == endStr) {
        return startStr;
      }
      return '$startStr - $endStr';
    } catch (e) {
      return '$start - $end'; // Fallback to original string if parsing fails
    }
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static DateTime parse(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return DateTime.now();

    try {
      return DateTime.parse(dateStr);
    } catch (_) {}

    try {
      return DateFormat("dd-MM-yyyy HH:mm:ss").parse(dateStr);
    } catch (_) {}

    try {
      return DateFormat("dd/MM/yyyy HH:mm:ss").parse(dateStr);
    } catch (_) {}

    try {
      return DateFormat("dd/MM/yyyy").parse(dateStr);
    } catch (_) {}

    return DateTime.now();
  }
}
