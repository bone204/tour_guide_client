import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tour_guide_app/common/bloc/lang/locale_cubit.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';

class LanguageTile extends StatefulWidget {
  final String code;
  final String label;
  final String flag;
  final bool selected;

  const LanguageTile({
    super.key,
    required this.code,
    required this.label,
    required this.flag,
    required this.selected,
  });

  @override
  State<LanguageTile> createState() => _LanguageTileState();
}

class _LanguageTileState extends State<LanguageTile> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<LocaleCubit>().setLocale(Locale(widget.code));
      },
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: _isPressed ? Colors.grey[200] : AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(8.r),
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
                Text(widget.flag, style: TextStyle(fontSize: 20.sp)),
                SizedBox(width: 10.w),
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: widget.selected
                            ? AppColors.primaryBlue
                            : AppColors.primaryBlack,
                      ),
                ),
              ],
            ),
            if (widget.selected)
              Icon(Icons.check, color: AppColors.primaryBlue, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
