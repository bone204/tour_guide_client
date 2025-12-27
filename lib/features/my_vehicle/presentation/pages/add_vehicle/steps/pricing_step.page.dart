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
  final double? priceFor4Hours;
  final double? priceFor8Hours;
  final double? priceFor12Hours;
  final double? priceFor2Days;
  final double? priceFor3Days;
  final double? priceFor5Days;
  final double? priceFor7Days;
  final String requirements;
  final String description;
  final bool isSubmitting;
  final Function({
    double? pricePerHour,
    double? pricePerDay,
    double? priceFor4Hours,
    double? priceFor8Hours,
    double? priceFor12Hours,
    double? priceFor2Days,
    double? priceFor3Days,
    double? priceFor5Days,
    double? priceFor7Days,
    required String requirements,
    required String description,
  })
  onSubmit;
  final VoidCallback onBack;

  const PricingStep({
    super.key,
    this.pricePerHour,
    this.pricePerDay,
    this.priceFor4Hours,
    this.priceFor8Hours,
    this.priceFor12Hours,
    this.priceFor2Days,
    this.priceFor3Days,
    this.priceFor5Days,
    this.priceFor7Days,
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

  // Optional prices interactions
  late TextEditingController _priceFor4HoursController;
  late TextEditingController _priceFor8HoursController;
  late TextEditingController _priceFor12HoursController;
  late TextEditingController _priceFor2DaysController;
  late TextEditingController _priceFor3DaysController;
  late TextEditingController _priceFor5DaysController;
  late TextEditingController _priceFor7DaysController;

  late TextEditingController _requirementsController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final formatter = NumberFormat('#,###', 'vi_VN');

    _pricePerHourController = _createController(widget.pricePerHour, formatter);
    _pricePerDayController = _createController(widget.pricePerDay, formatter);

    _priceFor4HoursController = _createController(
      widget.priceFor4Hours,
      formatter,
    );
    _priceFor8HoursController = _createController(
      widget.priceFor8Hours,
      formatter,
    );
    _priceFor12HoursController = _createController(
      widget.priceFor12Hours,
      formatter,
    );
    _priceFor2DaysController = _createController(
      widget.priceFor2Days,
      formatter,
    );
    _priceFor3DaysController = _createController(
      widget.priceFor3Days,
      formatter,
    );
    _priceFor5DaysController = _createController(
      widget.priceFor5Days,
      formatter,
    );
    _priceFor7DaysController = _createController(
      widget.priceFor7Days,
      formatter,
    );

    _requirementsController = TextEditingController(text: widget.requirements);
    _descriptionController = TextEditingController(text: widget.description);
  }

  TextEditingController _createController(
    double? value,
    NumberFormat formatter,
  ) {
    return TextEditingController(
      text: value != null ? formatter.format(value) : '',
    );
  }

  @override
  void dispose() {
    _pricePerHourController.dispose();
    _pricePerDayController.dispose();
    _priceFor4HoursController.dispose();
    _priceFor8HoursController.dispose();
    _priceFor12HoursController.dispose();
    _priceFor2DaysController.dispose();
    _priceFor3DaysController.dispose();
    _priceFor5DaysController.dispose();
    _priceFor7DaysController.dispose();
    _requirementsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        pricePerHour: _parsePrice(_pricePerHourController.text),
        pricePerDay: _parsePrice(_pricePerDayController.text),
        priceFor4Hours: _parsePrice(_priceFor4HoursController.text),
        priceFor8Hours: _parsePrice(_priceFor8HoursController.text),
        priceFor12Hours: _parsePrice(_priceFor12HoursController.text),
        priceFor2Days: _parsePrice(_priceFor2DaysController.text),
        priceFor3Days: _parsePrice(_priceFor3DaysController.text),
        priceFor5Days: _parsePrice(_priceFor5DaysController.text),
        priceFor7Days: _parsePrice(_priceFor7DaysController.text),
        requirements: _requirementsController.text,
        description: _descriptionController.text,
      );
    }
  }

  double? _parsePrice(String text) {
    if (text.isEmpty) return null;
    return double.tryParse(text.replaceAll('.', ''));
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
                child: _buildPriceField(
                  controller: _pricePerHourController,
                  label: '${locale.price} / ${locale.hour}',
                  locale: locale,
                  isRequired: true,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildPriceField(
                  controller: _pricePerDayController,
                  label: '${locale.price} / ${locale.day}',
                  locale: locale,
                  isRequired: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          ExpansionTile(
            title: Text(
              locale
                  .priceRange, // Using generic 'Price range' or similar if existing, else 'More Pricing Options'
              style: Theme.of(context).textTheme.titleSmall,
            ),
            childrenPadding: EdgeInsets.zero,
            tilePadding: EdgeInsets.zero,
            children: [
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: _buildPriceField(
                      controller: _priceFor4HoursController,
                      label: locale.priceFor4Hours,
                      locale: locale,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildPriceField(
                      controller: _priceFor8HoursController,
                      label: locale.priceFor8Hours,
                      locale: locale,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _buildPriceField(
                      controller: _priceFor12HoursController,
                      label: locale.priceFor12Hours,
                      locale: locale,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildPriceField(
                      controller: _priceFor2DaysController,
                      label: locale.priceFor2Days,
                      locale: locale,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _buildPriceField(
                      controller: _priceFor3DaysController,
                      label: locale.priceFor3Days,
                      locale: locale,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildPriceField(
                      controller: _priceFor5DaysController,
                      label: locale.priceFor5Days,
                      locale: locale,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _buildPriceField(
                      controller: _priceFor7DaysController,
                      label: locale.priceFor7Days,
                      locale: locale,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              SizedBox(height: 16.h),
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
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildPriceField({
    required TextEditingController controller,
    required String label,
    required AppLocalizations locale,
    bool isRequired = false,
  }) {
    return CustomTextField(
      label: label,
      placeholder: '0',
      keyboardType: TextInputType.number,
      controller: controller,
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSubtitle,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      validator: (val) {
        if (isRequired) {
          if (val == null || val.isEmpty) {
            return locale.fieldRequired(label);
          }
        }
        if (val != null &&
            val.isNotEmpty &&
            double.tryParse(val.replaceAll('.', '')) == null) {
          return locale.pleaseEnterValidPrice;
        }
        return null;
      },
    );
  }
}
