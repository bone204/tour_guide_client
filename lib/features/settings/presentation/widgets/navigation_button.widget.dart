// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';

class NavigationButton extends StatefulWidget {
  final IconData leadingIcon;
  final String title;
  final IconData? trailingIcon;
  final VoidCallback onTap;
  final bool isSelected;

  const NavigationButton({
    super.key,
    required this.leadingIcon,
    required this.title,
    this.trailingIcon,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: _isPressed ? Colors.grey[200] : AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.1),
              spreadRadius: 0.5,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(widget.leadingIcon, color: AppColors.textPrimary, size: 24.sp),
                SizedBox(width: 12),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ],
            ),
            Icon(widget.trailingIcon, color: AppColors.textPrimary, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
