import 'package:intl/intl.dart';
import 'package:tour_guide_app/common_libs.dart';

class DateHourPickerField extends StatefulWidget {
  final String? label;
  final String placeholder;
  final DateTime? initialDateTime;
  final void Function(DateTime) onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const DateHourPickerField({
    super.key,
    this.label,
    required this.placeholder,
    required this.onChanged,
    this.initialDateTime,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<DateHourPickerField> createState() => _DateHourPickerFieldState();
}

class _DateHourPickerFieldState extends State<DateHourPickerField> {
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDateTime;
  }

  Future<void> _pickDateTime() async {
    DateTime now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? now),
    );
    if (time == null) return;

    final pickedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    setState(() => selectedDateTime = pickedDateTime);
    widget.onChanged(pickedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    final displayText = selectedDateTime != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime!)
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
          onTap: _pickDateTime,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.secondaryGrey, width: 1.w),
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
                      color: selectedDateTime == null ? AppColors.textSubtitle : AppColors.primaryBlack,
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
