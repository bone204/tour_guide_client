import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDateRange(String start, String end) {
    if (start.isEmpty || end.isEmpty) return '';
    try {
      final startDate = DateTime.parse(start);
      final endDate = DateTime.parse(end);
      final formatter = DateFormat('dd/MM/yyyy');
      return '${formatter.format(startDate)} - ${formatter.format(endDate)}';
    } catch (e) {
      return '$start - $end'; // Fallback to original string if parsing fails
    }
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
