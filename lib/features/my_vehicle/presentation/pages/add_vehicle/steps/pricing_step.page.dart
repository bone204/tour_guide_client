import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/currency_input_formatter.dart';
import 'package:intl/intl.dart';

import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';

class PricingStep extends StatefulWidget {
  final double? pricePerHour;
  final double? pricePerDay;
  final String requirements;
  final String description;
  final bool isSubmitting;
  final Function({
    double? pricePerHour,
    double? pricePerDay,
    required String requirements,
    required String description,
  })
  onSubmit;
  final VoidCallback onBack;

  const PricingStep({
    super.key,
    this.pricePerHour,
    this.pricePerDay,
    required this.requirements,
    required this.description,
    this.isSubmitting = false,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  State<PricingStep> createState() => _PricingStepState();
}

class _PricingStepState extends State<PricingStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _pricePerHourController;
  late TextEditingController _pricePerDayController;
  late TextEditingController _requirementsController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final formatter = NumberFormat('#,###', 'vi_VN');
    _pricePerHourController = TextEditingController(
      text:
          widget.pricePerHour != null
              ? formatter.format(widget.pricePerHour)
              : '',
    );
    _pricePerDayController = TextEditingController(
      text:
          widget.pricePerDay != null
              ? formatter.format(widget.pricePerDay)
              : '',
    );
    _requirementsController = TextEditingController(text: widget.requirements);
    _descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    _pricePerHourController.dispose();
    _pricePerDayController.dispose();
    _requirementsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        pricePerHour: double.tryParse(
          _pricePerHourController.text.replaceAll('.', ''),
        ),
        pricePerDay: double.tryParse(
          _pricePerDayController.text.replaceAll('.', ''),
        ),
        requirements: _requirementsController.text,
        description: _descriptionController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: '${locale.price} / ${locale.hour}',
                  placeholder: '0',
                  keyboardType: TextInputType.number,
                  controller: _pricePerHourController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyInputFormatter(),
                  ],
                  suffixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: Text(
                          'đ',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSubtitle,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return locale.fieldRequired(
                        '${locale.price} / ${locale.hour}',
                      );
                    }
                    if (double.tryParse(val.replaceAll('.', '')) == null) {
                      return locale.pleaseEnterValidPrice;
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomTextField(
                  label: '${locale.price} / ${locale.day}',
                  placeholder: '0',
                  keyboardType: TextInputType.number,
                  controller: _pricePerDayController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyInputFormatter(),
                  ],
                  suffixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: Text(
                          'đ',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSubtitle,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty)
                      return locale.fieldRequired(
                        '${locale.price} / ${locale.day}',
                      );
                    if (double.tryParse(val.replaceAll('.', '')) == null)
                      return locale.pleaseEnterValidPrice;
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            label: locale.requirements,
            placeholder: locale.requirements,
            maxLines: 3,
            controller: _requirementsController,
          ),
          SizedBox(height: 16.h),
          CustomTextField(
            label: locale.description,
            placeholder: locale.description,
            maxLines: 3,
            controller: _descriptionController,
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onBack,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryGrey,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    locale.back,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: widget.isSubmitting ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child:
                      widget.isSubmitting
                          ? SizedBox(
                            height: 20.h,
                            width: 20.h,
                            child: CircularProgressIndicator(
                              color: AppColors.primaryWhite,
                              strokeWidth: 2,
                            ),
                          )
                          : Text(
                            locale.register,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: AppColors.primaryWhite,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
