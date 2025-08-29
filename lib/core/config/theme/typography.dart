import 'package:tour_guide_app/common_libs.dart';

class AppTypography {
  // Font constants - sử dụng đúng family NotoSans đã khai báo
  static const String fontThin = 'NotoSans-Thin';
  static const String fontExtraLight = 'NotoSans-ExtraLight';
  static const String fontLight = 'NotoSans-Light';
  static const String fontRegular = 'NotoSans-Regular';
  static const String fontMedium = 'NotoSans-Medium';
  static const String fontSemiBold = 'NotoSans-SemiBold';
  static const String fontBold = 'NotoSans-Bold';
  static const String fontExtraBold = 'NotoSans-ExtraBold';
  static const String fontBlack = 'NotoSans-Black';
  static const String fontItalic = 'NotoSans-Italic';

  static TextTheme getTextTheme() {
    return TextTheme(
      headlineLarge: TextStyle(
          fontFamily: fontExtraBold, fontSize: 26, color: AppColors.textPrimary),
      headlineMedium: TextStyle(
          fontFamily: fontExtraBold, fontSize: 24, color: AppColors.textPrimary),
      headlineSmall: TextStyle(
          fontFamily: fontExtraBold, fontSize: 22, color: AppColors.textPrimary),
      bodyLarge: TextStyle(
          fontFamily: fontRegular, fontSize: 16, color: AppColors.textPrimary),
      bodyMedium: TextStyle(
          fontFamily: fontRegular, fontSize: 14, color: AppColors.textPrimary),
      bodySmall: TextStyle(
          fontFamily: fontRegular, fontSize: 12, color: AppColors.textPrimary),
      labelLarge: TextStyle(
          fontFamily: fontMedium, fontSize: 18, color: AppColors.textPrimary),
      labelMedium: TextStyle(
          fontFamily: fontMedium, fontSize: 16, color: AppColors.textPrimary),
      labelSmall: TextStyle(
          fontFamily: fontMedium, fontSize: 14, color: AppColors.textPrimary),
      titleLarge: TextStyle(
          fontFamily: fontSemiBold, fontSize: 20, color: AppColors.textPrimary),
      titleMedium: TextStyle(
          fontFamily: fontSemiBold, fontSize: 18, color: AppColors.textPrimary),
      titleSmall: TextStyle(
          fontFamily: fontSemiBold, fontSize: 16, color: AppColors.textPrimary),
      displayLarge: TextStyle(
          fontFamily: fontSemiBold, fontSize: 14, color: AppColors.textPrimary),
      displayMedium: TextStyle(
          fontFamily: fontSemiBold, fontSize: 12, color: AppColors.textPrimary),
      displaySmall: TextStyle(
          fontFamily: fontSemiBold, fontSize: 10, color: AppColors.textPrimary),
    );
  }

  static TextTheme get textTheme => getTextTheme();
}
