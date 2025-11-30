import 'package:tour_guide_app/common_libs.dart';

class PassengerInfoForm extends StatelessWidget {
  final int seatNumber;
  final Function(String name, String phone) onChanged;

  const PassengerInfoForm({
    Key? key,
    required this.seatNumber,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Ghế $seatNumber',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.primaryWhite,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Thông tin hành khách',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Name Field
          TextField(
            decoration: InputDecoration(
              labelText: '${AppLocalizations.of(context)!.fullNameLabel} *',
              hintText: AppLocalizations.of(context)!.enterFullNameHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppColors.textSubtitle.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppColors.textSubtitle.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
              ),
              prefixIcon: Icon(Icons.person_outline, color: AppColors.primaryBlue),
            ),
            onChanged: (value) {
              // TODO: Call onChanged with name and phone
            },
          ),

          SizedBox(height: 12.h),

          // Phone Field
          TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: '${AppLocalizations.of(context)!.phoneNumber} *',
              hintText: AppLocalizations.of(context)!.enterPhoneNumberHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppColors.textSubtitle.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppColors.textSubtitle.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
              ),
              prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primaryBlue),
            ),
            onChanged: (value) {
              // TODO: Call onChanged with name and phone
            },
          ),
        ],
      ),
    );
  }
}

