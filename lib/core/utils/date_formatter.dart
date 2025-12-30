import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDateRange(String start, String end) {
    if (start.isEmpty || end.isEmpty) return '';
    try {
      final startDate = parse(start);
      final endDate = parse(end);
      final formatter = DateFormat('dd/MM/yyyy');
      return '${formatter.format(startDate)} - ${formatter.format(endDate)}';
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
      // First try standard ISO 8601
      return DateTime.parse(dateStr);
    } catch (_) {
      try {
        // Try the custom format from server: dd-MM-yyyy HH:mm:ss
        return DateFormat("dd-MM-yyyy HH:mm:ss").parse(dateStr);
      } catch (_) {
        try {
          // Try another common format: dd/MM/yyyy HH:mm:ss
          return DateFormat("dd/MM/yyyy HH:mm:ss").parse(dateStr);
        } catch (e) {
          // print("Error parsing date: $dateStr, error: $e");
          return DateTime.now();
        }
      }
    }
  }
}
