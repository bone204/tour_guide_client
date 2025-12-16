import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/picker/date_picker.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/common_libs.dart';

import 'package:tour_guide_app/common/widgets/loading/dialog_loading.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/create_itinerary/create_itinerary_cubit.dart';
import 'package:tour_guide_app/common/constants/app_route.constant.dart';
import 'package:tour_guide_app/service_locator.dart';

class CreateItineraryPage extends StatefulWidget {
  final String province;

  const CreateItineraryPage({super.key, required this.province});

  @override
  State<CreateItineraryPage> createState() => _CreateItineraryPageState();
}

class _CreateItineraryPageState extends State<CreateItineraryPage> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => sl<CreateItineraryCubit>()..initialize(widget.province),
      child: BlocListener<CreateItineraryCubit, CreateItineraryState>(
        listener: (context, state) {
          if (state.status == CreateItineraryStatus.loading) {
            LoadingDialog.show(context);
          } else if (state.status == CreateItineraryStatus.success) {
            LoadingDialog.hide(context);
            eventBus.fire(CreateItinerarySuccessEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.createItinerarySuccess,
                ),
              ),
            );
            Navigator.pushReplacementNamed(
              context,
              AppRouteConstant.itineraryDetail,
              arguments: state.createdItinerary!.id,
            );
          } else if (state.status == CreateItineraryStatus.failure) {
            LoadingDialog.hide(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      AppLocalizations.of(context)!.somethingWentWrong,
                ),
              ),
            );
          }
        },
        child: BlocBuilder<CreateItineraryCubit, CreateItineraryState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                appBar: CustomAppBar(
                  title: AppLocalizations.of(context)!.createItinerary,
                  showBackButton: true,
                  onBackPressed: () => Navigator.pop(context),
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildReadOnlyField(
                        context,
                        label: AppLocalizations.of(context)!.location,
                        value: widget.province,
                        icon: AppIcons.location,
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        label: AppLocalizations.of(context)!.itineraryName,
                        placeholder:
                            AppLocalizations.of(context)!.itineraryName,
                        controller: _titleController,
                        onChanged:
                            (value) => context
                                .read<CreateItineraryCubit>()
                                .nameChanged(value),
                        prefixIconData: Icons.edit_note,
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: DatePickerField(
                              label: AppLocalizations.of(context)!.startDate,
                              placeholder:
                                  AppLocalizations.of(context)!.noDateSelected,
                              initialDate: state.startDate,
                              onChanged: (date) {
                                context
                                    .read<CreateItineraryCubit>()
                                    .dateChanged(startDate: date);
                              },
                              prefixIcon: SvgPicture.asset(
                                AppIcons.calendar,
                                width: 20.w,
                                height: 20.h,
                                color: AppColors.primaryBlack,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: DatePickerField(
                              label: AppLocalizations.of(context)!.endDate,
                              placeholder:
                                  AppLocalizations.of(context)!.noDateSelected,
                              initialDate: state.endDate,
                              onChanged: (date) {
                                context
                                    .read<CreateItineraryCubit>()
                                    .dateChanged(endDate: date);
                              },
                              prefixIcon: SvgPicture.asset(
                                AppIcons.calendar,
                                width: 20.w,
                                height: 20.h,
                                color: AppColors.primaryBlack,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _buildNumberDisplay(
                        context,
                        label: AppLocalizations.of(context)!.itineraryDays,
                        value: state.numberOfDays.toString(),
                      ),
                      SizedBox(height: 32.h),
                      PrimaryButton(
                        title: AppLocalizations.of(context)!.createItinerary,
                        onPressed:
                            state.isValid
                                ? () =>
                                    context
                                        .read<CreateItineraryCubit>()
                                        .submitted()
                                : null,
                        backgroundColor:
                            state.isValid
                                ? AppColors.primaryBlue
                                : AppColors.primaryGrey,
                        textColor: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(
    BuildContext context, {
    required String label,
    required String value,
    required String icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.displayLarge),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.primaryGrey, width: 1.w),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SvgPicture.asset(
                  icon,
                  width: 20.w,
                  height: 20.h,
                  color: AppColors.primaryBlack,
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primaryBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNumberDisplay(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.displayLarge),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.primaryBlue, width: 1.w),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.primaryBlue,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.day,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.primaryBlue),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
