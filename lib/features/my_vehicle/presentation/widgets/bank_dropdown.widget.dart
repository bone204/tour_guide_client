import 'package:tour_guide_app/common_libs.dart';

class BankDropdown extends StatelessWidget {
  final String? selectedBank;
  final Function(String?) onChanged;
  final String? label;

  const BankDropdown({
    super.key,
    required this.selectedBank,
    required this.onChanged,
    this.label,
  });

  static const List<String> vietnameseBanks = [
    'Vietcombank - Ngân hàng TMCP Ngoại Thương Việt Nam',
    'VietinBank - Ngân hàng TMCP Công Thương Việt Nam',
    'BIDV - Ngân hàng TMCP Đầu tư và Phát triển Việt Nam',
    'Agribank - Ngân hàng Nông nghiệp và Phát triển Nông thôn Việt Nam',
    'ACB - Ngân hàng TMCP Á Châu',
    'Techcombank - Ngân hàng TMCP Kỹ Thương Việt Nam',
    'MB Bank - Ngân hàng TMCP Quân Đội',
    'TPBank - Ngân hàng TMCP Tiên Phong',
    'VPBank - Ngân hàng TMCP Việt Nam Thịnh Vượng',
    'Sacombank - Ngân hàng TMCP Sài Gòn Thương Tín',
    'HDBank - Ngân hàng TMCP Phát triển TP. HCM',
    'VIB - Ngân hàng TMCP Quốc Tế',
    'SHB - Ngân hàng TMCP Sài Gòn - Hà Nội',
    'MSB - Ngân hàng TMCP Hàng Hải',
    'OCB - Ngân hàng TMCP Phương Đông',
  ];

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
          height: 48.h, // Match CustomTextField height
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.secondaryGrey, width: 1.w),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedBank,
              isExpanded: true,
              hint: Text(
                AppLocalizations.of(context)!.selectBank,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              icon: Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.primaryGrey,
                ),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
              dropdownColor: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(8.r),
              items:
                  vietnameseBanks.map((String bank) {
                    return DropdownMenuItem<String>(
                      value: bank,
                      child: Text(
                        bank,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
