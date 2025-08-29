import 'package:tour_guide_app/common_libs.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.textSecondary,
      textTheme: AppTypography.getTextTheme(),
    );
  }
}
