import 'package:tour_guide_app/common_libs.dart';

enum TripType {
  oneWay,
  roundTrip,
}

class TripTypeSelector extends StatelessWidget {
  final TripType initialType;
  final Function(TripType) onChanged;

  const TripTypeSelector({
    Key? key,
    required this.initialType,
    required this.onChanged,
  }) : super(key: key);

  String _getTripTypeLabel(TripType type) {
    switch (type) {
      case TripType.oneWay:
        return 'Một chiều';
      case TripType.roundTrip:
        return 'Khứ hồi';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.textSubtitle.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: TripType.values.map((type) {
          final isSelected = type == initialType;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(type),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Center(
                  child: Text(
                    _getTripTypeLabel(type),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: isSelected
                              ? AppColors.primaryWhite
                              : AppColors.textSubtitle,
                        ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

