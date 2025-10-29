import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common_libs.dart';

class DatePickerField extends StatefulWidget {
  final String? label;
  final String placeholder;
  final DateTime? initialDate;
  final void Function(DateTime) onChanged;
  final Widget? prefixIcon;

  const DatePickerField({
    super.key,
    this.label,
    required this.placeholder,
    required this.onChanged,
    this.initialDate,
    this.prefixIcon,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() => selectedDate = date);
      widget.onChanged(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayText = widget.placeholder;
    if (selectedDate != null) {
      displayText = '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
    }

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
          onTap: _pickDate,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.primaryGrey, width: 1.w),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: widget.prefixIcon ?? SvgPicture.asset(
                    AppIcons.calendar,
                    width: 20.w,
                    height: 20.h,
                    color: AppColors.primaryBlack,
                  ),
                ),
                Expanded(
                  child: Text(
                    displayText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: selectedDate == null ? AppColors.textSubtitle : AppColors.primaryBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

