import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';

class MyVehiclePage extends StatelessWidget {
  const MyVehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: "My Vehicle", showBackButton: false),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.directions_car_outlined,
                  size: 64.sp,
                  color: AppColors.primaryBlue,
                ),
              ),
              SizedBox(height: 24.h),
              // Title
              Text(
                'No Vehicles Yet',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 12.h),
              // Description
              Text(
                'Start earning by registering your vehicle for rental services',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              // Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      AppRouteConstant.vehicleRentalRegister,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: AppColors.primaryWhite,
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Register Vehicle',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.primaryWhite,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // Information card
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.secondaryGrey,
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Benefits of registering your vehicle:',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(height: 12.h),
                    _buildBenefitItem(
                      context,
                      icon: Icons.attach_money,
                      text: 'Earn extra income from your vehicle',
                    ),
                    SizedBox(height: 8.h),
                    _buildBenefitItem(
                      context,
                      icon: Icons.verified_user,
                      text: 'Insurance coverage for all rentals',
                    ),
                    SizedBox(height: 8.h),
                    _buildBenefitItem(
                      context,
                      icon: Icons.support_agent,
                      text: '24/7 customer support',
                    ),
                    SizedBox(height: 8.h),
                    _buildBenefitItem(
                      context,
                      icon: Icons.schedule,
                      text: 'Flexible rental schedule',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.sp,
          color: AppColors.primaryBlue,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSubtitle,
                ),
          ),
        ),
      ],
    );
  }
}

