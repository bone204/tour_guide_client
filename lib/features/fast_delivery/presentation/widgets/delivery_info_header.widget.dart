import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common_libs.dart';

class DeliveryInfoHeader extends StatelessWidget {
  final String? senderName;
  final String? senderPhone;
  final String? senderAddress;
  final String? receiverName;
  final String? receiverPhone;
  final String? receiverAddress;

  const DeliveryInfoHeader({
    super.key,
    this.senderName,
    this.senderPhone,
    this.senderAddress,
    this.receiverName,
    this.receiverPhone,
    this.receiverAddress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue,
            AppColors.primaryBlue.withOpacity(0.88),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryWhite.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryWhite.withOpacity(0.08),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pickup section - Split into 2 columns
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column - Icon and line
                    Column(
                      children: [
                        // Pickup icon
                        SvgPicture.asset(
                          AppIcons.location,
                          width: 20.w,
                          height: 20.h,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primaryWhite,
                            BlendMode.srcIn,
                          ),
                        ),
                        
                        // Dotted line connector - Auto sized
                        SizedBox(
                          height: 120.h,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Calculate number of dots based on available height
                              final dotHeight = 4.h;
                              final dotSpacing = 4.h;
                              final totalDotHeight = dotHeight + dotSpacing;
                              final numberOfDots = (constraints.maxHeight / totalDotHeight).floor();
                              
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List.generate(
                                  numberOfDots > 0 ? numberOfDots : 1,
                                  (index) => Container(
                                    width: 2,
                                    height: dotHeight,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryWhite,
                                      borderRadius: BorderRadius.circular(2.r),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(width: 16.w),
                    
                    // Right column - Pickup content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Điểm lấy hàng',
                            style: theme.displayLarge?.copyWith(
                              color: AppColors.primaryWhite.withOpacity(0.85),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            senderAddress ?? 'Chưa có địa chỉ',
                            style: theme.titleMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryWhite.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.user,
                                    width: 14.w,
                                    height: 14.h,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.primaryWhite,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Flexible(
                                    child: Text(
                                      senderName ?? 'Chưa có tên',
                                      style: theme.displayMedium?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                                      width: 1,
                                      height: 14.h,
                                      color: AppColors.primaryWhite.withOpacity(0.3),
                                    ),
                                    SvgPicture.asset(
                                    AppIcons.contact,
                                    width: 14.w,
                                    height: 14.h,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.primaryWhite,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      senderPhone ?? 'Chưa có số điện thoại',
                                      style: theme.displayMedium?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Delivery section - Normal row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AppIcons.location,
                      width: 20.w,
                      height: 20.h,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primaryGreen,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Điểm giao hàng',
                            style: theme.displayLarge?.copyWith(
                              color: AppColors.primaryWhite.withOpacity(0.85),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            receiverAddress ?? 'Chưa có địa chỉ',
                            style: theme.titleMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (receiverName != null) ...[
                            SizedBox(height: 10.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryWhite.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    AppIcons.user,
                                    width: 14.w,
                                    height: 14.h,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.primaryWhite,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Flexible(
                                    child: Text(
                                      receiverName!,
                                      style: theme.displayMedium?.copyWith(
                                        color: AppColors.primaryWhite,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (receiverPhone != null) ...[
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                                      width: 1,
                                      height: 14.h,
                                      color: AppColors.primaryWhite.withOpacity(0.3),
                                    ),
                                    SvgPicture.asset(
                                    AppIcons.contact,
                                    width: 14.w,
                                    height: 14.h,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.primaryWhite,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      receiverPhone!,
                                      style: theme.displayMedium?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
