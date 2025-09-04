import 'package:tour_guide_app/common_libs.dart';

class AppTypography {
  // Font constants - sử dụng đúng family Inter đã khai báo
  static const String fontLight = 'Inter-Light';
  static const String fontRegular = 'Inter-Regular';
  static const String fontMedium = 'Inter-Medium';
  static const String fontSemiBold = 'Inter-SemiBold';
  static const String fontBold = 'Inter-Bold';
  static const String fontExtraBold = 'Inter-ExtraBold';
  static const String fontBlack = 'Inter-Black';

  static TextTheme getTextTheme() {
    return TextTheme(
      headlineLarge: TextStyle(
        fontFamily: fontBold,
        fontSize: 26.sp,
        color: AppColors.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontBold,
        fontSize: 24.sp,
        color: AppColors.textPrimary,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontBold,
        fontSize: 22.sp,
        color: AppColors.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontRegular,
        fontSize: 16.sp,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontRegular,
        fontSize: 14.sp,
        color: AppColors.textPrimary,
      ),
      bodySmall: TextStyle(
        fontFamily: fontRegular,
        fontSize: 12.sp,
        color: AppColors.textPrimary,
      ),
      labelLarge: TextStyle(
        fontFamily: fontMedium,
        fontSize: 18.sp,
        color: AppColors.textPrimary,
      ),
      labelMedium: TextStyle(
        fontFamily: fontMedium,
        fontSize: 16.sp,
        color: AppColors.textPrimary,
      ),
      labelSmall: TextStyle(
        fontFamily: fontMedium,
        fontSize: 14.sp,
        color: AppColors.textPrimary,
      ),
      titleLarge: TextStyle(
        fontFamily: fontSemiBold,
        fontSize: 20.sp,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: fontSemiBold,
        fontSize: 18.sp,
        color: AppColors.textPrimary,
      ),
      titleSmall: TextStyle(
        fontFamily: fontSemiBold,
        fontSize: 16.sp,
        color: AppColors.textPrimary,
      ),
      displayLarge: TextStyle(
        fontFamily: fontSemiBold,
        fontSize: 14.sp,
        color: AppColors.textPrimary,
      ),
      displayMedium: TextStyle(
        fontFamily: fontSemiBold,
        fontSize: 12.sp,
        color: AppColors.textPrimary,
      ),
      displaySmall: TextStyle(
        fontFamily: fontSemiBold,
        fontSize: 10.sp,
        color: AppColors.textPrimary,
      ),
    );
  }

  static TextTheme get textTheme => getTextTheme();
}
