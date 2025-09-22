import 'package:tour_guide_app/common_libs.dart';

class HourPickerField extends StatefulWidget {
  final String? label;
  final String placeholder;
  final TimeOfDay? initialTime;
  final void Function(TimeOfDay) onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const HourPickerField({
    super.key,
    this.label,
    required this.placeholder,
    required this.onChanged,
    this.initialTime,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<HourPickerField> createState() => _HourPickerFieldState();
}

class _HourPickerFieldState extends State<HourPickerField> {
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
  }

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? now,
    );
    if (picked == null) return;

    setState(() => selectedTime = picked);
    widget.onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final displayText = selectedTime != null
        ? selectedTime!.format(context)
        : widget.placeholder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          SizedBox(height: 8.h),
        ],
        GestureDetector(
          onTap: _pickTime,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.primaryGrey, width: 1.w),
            ),
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: widget.prefixIcon!,
                  ),
                ],
                Expanded(
                  child: Text(
                    displayText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: selectedTime == null ? AppColors.textSubtitle : AppColors.primaryBlack,
                    ),
                  ),
                ),
                if (widget.suffixIcon != null) widget.suffixIcon!,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
