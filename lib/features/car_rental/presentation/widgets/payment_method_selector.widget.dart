import 'package:tour_guide_app/common_libs.dart';

class PaymentMethodSelector extends StatelessWidget {
  final List<Map<String, String>> bankOptions;
  final String? selectedBank;
  final Function(String) onSelect;

  const PaymentMethodSelector({
    super.key,
    required this.bankOptions,
    required this.selectedBank,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bankOptions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, 
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 1.5, 
      ),
      itemBuilder: (context, index) {
        final bank = bankOptions[index];
        final isSelected = selectedBank == bank['id'];
        return GestureDetector(
          onTap: () => onSelect(bank['id']!),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isSelected ? AppColors.primaryBlue : AppColors.secondaryGrey,
                width: 2,
              ),
              color: Colors.white,
            ),
            child: Image.asset(bank['image']!, fit: BoxFit.contain),
          ),
        );
      },
    );
  }
}
