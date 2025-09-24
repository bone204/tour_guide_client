import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';

class RewardPointSelector extends StatelessWidget {
  final int travelPoint;
  final int travelPointToUse;
  final ValueChanged<int> onChanged;

  const RewardPointSelector({
    super.key,
    required this.travelPoint,
    required this.travelPointToUse,
    required this.onChanged,
  });

  List<DropdownMenuItem<int>> _buildDropdownItems(BuildContext context) {
    final items = <DropdownMenuItem<int>>[
      DropdownMenuItem(
        value: 0,
        child: Text(AppLocalizations.of(context)!.noUsePoint),
      ),
    ];

    for (var i = 1000; i <= travelPoint; i += 1000) {
      items.add(
        DropdownMenuItem(
          value: i,
          child: Text(
            "${Formatter.number(i)} "
            "${AppLocalizations.of(context)!.points} "
            "(-${Formatter.currency(i)})",
          ),
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primaryOrange, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                AppIcons.star,
                width: 20.w,
                height: 20.h,
                color: AppColors.primaryOrange,
              ),
              SizedBox(width: 8.w),
              Text(
                AppLocalizations.of(context)!.useRewardPoint,
                style: theme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            "${AppLocalizations.of(context)!.availablePoints}: ${Formatter.number(travelPoint)}",
            style: theme.bodySmall?.copyWith(
              color: AppColors.textSubtitle,
            ),
          ),
          SizedBox(height: 12.h),
          DropdownButtonFormField<int>(
            value: travelPointToUse,
            items: _buildDropdownItems(context),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onChanged: (value) => onChanged(value ?? 0),
          ),
        ],
      ),
    );
  }
}
