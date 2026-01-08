import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/services/bank/data/models/bank.dart';

class BankDropdown extends StatelessWidget {
  final List<Bank> banks;
  final Bank? selectedBank;
  final bool isLoading;
  final ValueChanged<Bank?> onChanged;
  final String? label;

  const BankDropdown({
    super.key,
    required this.banks,
    required this.selectedBank,
    required this.isLoading,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.displayLarge),
          SizedBox(height: 6.h),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.secondaryGrey, width: 1.w),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<Bank>(
              isExpanded: true,
              value: selectedBank,
              hint: Text(
                isLoading
                    ? AppLocalizations.of(context)!.loading
                    : AppLocalizations.of(context)!.selectBank,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
              ),
              items:
                  banks.map((Bank bank) {
                    return DropdownMenuItem<Bank>(
                      value: bank,
                      child: Row(
                        children: [
                          if (bank.logo.isNotEmpty)
                            Image.network(
                              bank.logo,
                              width: 30.w,
                              height: 30.w,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      SizedBox(width: 30.w, height: 30.w),
                            ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              '${bank.shortName} - ${bank.name}',
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: onChanged,
              buttonStyleData: ButtonStyleData(
                padding: EdgeInsets.only(right: 12.w),
                height: 48.h,
              ),
              iconStyleData: IconStyleData(
                icon: Icon(Icons.arrow_drop_down_sharp),
                iconSize: 24.w,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                maxHeight: 300.h,
              ),
              menuItemStyleData: MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
