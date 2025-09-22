import 'package:intl/intl.dart';
import 'package:tour_guide_app/common_libs.dart'; 

class PriceRangeSlider extends StatefulWidget {
  final double min;
  final double max;
  final double start;
  final double end;
  final Function(RangeValues) onChanged;

  const PriceRangeSlider({
    super.key,
    required this.min,
    required this.max,
    required this.start,
    required this.end,
    required this.onChanged,
  });

  @override
  State<PriceRangeSlider> createState() => _PriceRangeSliderState();
}

class _PriceRangeSliderState extends State<PriceRangeSlider> {
  late RangeValues _currentRange;
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'vi_VN', 
    symbol: '₫', 
    decimalDigits: 0
  );

  @override
  void initState() {
    super.initState();
    _currentRange = RangeValues(widget.start, widget.end);
  }

  @override
  Widget build(BuildContext context) {
    final divisions = ((widget.max - widget.min) ~/ 50000).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context)!.priceRange}:   ${_currencyFormat.format(_currentRange.start)} - ${_currencyFormat.format(_currentRange.end)}',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        SizedBox(height: 12.h),
        RangeSlider(
          values: _currentRange,
          min: widget.min,
          max: widget.max,
          divisions: divisions,
          labels: RangeLabels(
            _currencyFormat.format(_currentRange.start),
            _currencyFormat.format(_currentRange.end),
          ),
          activeColor: AppColors.primaryBlue,
          inactiveColor: AppColors.secondaryGrey,
          onChanged: (values) {
            setState(() => _currentRange = values);
            widget.onChanged(values);
          },
        ),
      ],
    );
  }
}
