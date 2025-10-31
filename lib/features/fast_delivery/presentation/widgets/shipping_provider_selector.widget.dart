import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/fast_delivery/data/models/shipping_provider.dart';

class ShippingProviderSelector extends StatelessWidget {
  final ShippingProvider? selectedProvider;
  final List<ShippingProvider> providers;
  final Function(ShippingProvider) onSelect;

  const ShippingProviderSelector({
    super.key,
    this.selectedProvider,
    required this.providers,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hãng giao hàng',
          style: theme.displayLarge,
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: () => _showProviderBottomSheet(context),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.secondaryGrey, width: 1.w),
            ),
            child: Row(
              children: [
                if (selectedProvider != null) ...[
                  Text(
                    selectedProvider!.logo,
                    style: TextStyle(fontSize: 24.sp),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      selectedProvider!.name,
                      style: theme.bodyMedium,
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: Text(
                      'Chọn hãng giao hàng',
                      style: theme.bodyMedium?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                    ),
                  ),
                ],
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.primaryGrey,
                  size: 24.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showProviderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryGrey,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Chọn hãng giao hàng',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 16.h),
              ...providers.map((provider) {
                final isSelected = selectedProvider?.id == provider.id;
                return InkWell(
                  onTap: () {
                    onSelect(provider);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    margin: EdgeInsets.only(bottom: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppColors.primaryBlue.withOpacity(0.1)
                          : AppColors.primaryWhite,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isSelected 
                            ? AppColors.primaryBlue 
                            : AppColors.secondaryGrey,
                        width: isSelected ? 2.w : 1.w,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          provider.logo,
                          style: TextStyle(fontSize: 28.sp),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            provider.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primaryBlue,
                            size: 24.sp,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}

