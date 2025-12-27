import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common_libs.dart';

class ItineraryDatePicker extends StatefulWidget {
  final String? label;
  final String placeholder;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime) onChanged;
  final Widget? prefixIcon;

  const ItineraryDatePicker({
    super.key,
    this.label,
    required this.placeholder,
    required this.onChanged,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.prefixIcon,
  });

  @override
  State<ItineraryDatePicker> createState() => _ItineraryDatePickerState();
}

class _ItineraryDatePickerState extends State<ItineraryDatePicker> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  void didUpdateWidget(covariant ItineraryDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      selectedDate = widget.initialDate;
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final first = widget.firstDate ?? now;
    final last = widget.lastDate ?? DateTime(2101);

    // Ensure initial focus date is valid
    DateTime initial = selectedDate ?? now;
    if (initial.isBefore(first)) initial = first;
    if (initial.isAfter(last)) initial = last;

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primaryBlue),
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
      displayText =
          '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
        ],
        InkWell(
          onTap: _pickDate,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.primaryGrey.withOpacity(0.5),
                width: 1.w,
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child:
                      widget.prefixIcon ??
                      SvgPicture.asset(
                        AppIcons.calendar,
                        width: 20.w,
                        height: 20.h,
                        colorFilter: ColorFilter.mode(
                          AppColors.primaryBlack,
                          BlendMode.srcIn,
                        ),
                      ),
                ),
                Expanded(
                  child: Text(
                    displayText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:
                          selectedDate == null
                              ? AppColors.textSubtitle
                              : AppColors.primaryBlack,
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
