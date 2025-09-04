// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';

class NavigationButton extends StatefulWidget {
  final String icon; 
  final String title;
  final String? trailingIcon;
  final VoidCallback onTap;
  final bool isSelected;

  const NavigationButton({
    super.key,
    required this.icon,
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
        duration: const Duration(milliseconds: 120),
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
                SvgPicture.asset(
                  widget.icon,
                  width: 24.w,
                  height: 24.h,
                  color: AppColors.textPrimary,
                ),
                SizedBox(width: 12.w),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ],
            ),
            if (widget.trailingIcon != null)
              SvgPicture.asset(
                widget.trailingIcon!,
                width: 20.w,
                height: 20.h,
                color: AppColors.textPrimary,
              ),
          ],
        ),
      ),
    );
  }
}
