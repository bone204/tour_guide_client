import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';

class RentalInfoStep extends StatefulWidget {
  final String? pricePerHour;
  final String? pricePerDay;
  final String? requirements;
  final Function({
    String? pricePerHour,
    String? pricePerDay,
    String? requirements,
  }) onSubmit;
  final VoidCallback onBack;

  const RentalInfoStep({
    super.key,
    this.pricePerHour,
    this.pricePerDay,
    this.requirements,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  State<RentalInfoStep> createState() => _RentalInfoStepState();
}

class _RentalInfoStepState extends State<RentalInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _pricePerHourController;
  late TextEditingController _pricePerDayController;
  late TextEditingController _requirementsController;

  @override
  void initState() {
    super.initState();
    _pricePerHourController = TextEditingController(text: widget.pricePerHour);
    _pricePerDayController = TextEditingController(text: widget.pricePerDay);
    _requirementsController = TextEditingController(text: widget.requirements);
  }

  @override
  void dispose() {
    _pricePerHourController.dispose();
    _pricePerDayController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  String? _validatePrice(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'Please enter a valid price';
    }
    return null;
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        pricePerHour: _pricePerHourController.text,
        pricePerDay: _pricePerDayController.text,
        requirements: _requirementsController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              label: 'Price Per Hour (VND)',
              placeholder: 'Enter price per hour',
              controller: _pricePerHourController,
              keyboardType: TextInputType.number,
              validator: (value) => _validatePrice(value, 'Price per hour'),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: 'Price Per Day (VND)',
              placeholder: 'Enter price per day',
              controller: _pricePerDayController,
              keyboardType: TextInputType.number,
              validator: (value) => _validatePrice(value, 'Price per day'),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: 'Requirements',
              placeholder: 'e.g. Valid driver license, deposit...',
              controller: _requirementsController,
              maxLines: 5,
            ),
            SizedBox(height: 32.h),
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
                      'Back',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
      ),
    );
  }
}

