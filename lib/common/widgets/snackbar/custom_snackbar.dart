import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SnackbarType { success, error, info, warning }

class CustomSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    EdgeInsetsGeometry? margin,
    bool onTop = false,
  }) {
    Color backgroundColor;
    IconData icon;
    Color iconColor;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = const Color(0xFF2E7D32); // Dark Green
        icon = Icons.check_circle_rounded;
        iconColor = const Color(0xFF1B5E20); // Darker Green for icon
        break;
      case SnackbarType.error:
        backgroundColor = const Color(0xFFC62828); // Dark Red
        icon = Icons.error_rounded;
        iconColor = const Color(0xFFB71C1C); // Darker Red for icon
        break;
      case SnackbarType.warning:
        backgroundColor = const Color(0xFFEF6C00); // Dark Orange
        icon = Icons.warning_rounded;
        iconColor = const Color(0xFFE65100); // Darker Orange for icon
        break;
      case SnackbarType.info:
        backgroundColor = const Color(0xFF1565C0); // Dark Blue
        icon = Icons.info_rounded;
        iconColor = const Color(0xFF0D47A1); // Darker Blue for icon
        break;
    }

    if (onTop) {
      _showOverlay(
        context,
        message,
        backgroundColor,
        icon,
        iconColor,
        duration,
        margin,
      );
      return;
    }

    final snackBar = SnackBar(
      content: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: iconColor.withOpacity(0.3), width: 1),
      ),
      margin: margin ?? EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      duration: duration,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void _showOverlay(
    BuildContext context,
    String message,
    Color backgroundColor,
    IconData icon,
    Color iconColor,
    Duration duration,
    EdgeInsetsGeometry? margin,
  ) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            bottom:
                20.h +
                MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
            left: 16.w,
            right: 16.w,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                margin: margin,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: iconColor.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: iconColor, size: 24.sp),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        message,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}
