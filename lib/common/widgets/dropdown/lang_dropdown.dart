import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:tour_guide_app/common/bloc/lang/locale_cubit.dart';
import 'package:tour_guide_app/common/bloc/lang/locale_state.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        String currentValue = "en";
        if (state is LocaleLoaded) {
          currentValue = state.locale.languageCode;
        }

        return DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            value: currentValue,
            isExpanded: true,
            buttonStyleData: ButtonStyleData(
              height: 36.h,
              width: 140.w,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.secondaryGrey),
              ),
            ),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down, size: 18.sp, color: AppColors.primaryBlack),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 160.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            items: [
              DropdownMenuItem(
                value: "en",
                child: Row(
                  children: [
                    const Text("🇺🇸"),
                    SizedBox(width: 8.w),
                    Text("English", style: Theme.of(context).textTheme.displayMedium),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: "vi",
                child: Row(
                  children: [
                    const Text("🇻🇳"),
                    SizedBox(width: 8.w),
                    Text("Tiếng Việt", style: Theme.of(context).textTheme.displayMedium),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                context.read<LocaleCubit>().setLocale(Locale(value));
              }
            },
          ),
        );
      },
    );
  }
}
