import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/image_picker_field.widget.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/business_type_selector.widget.dart';

class TaxInfoStep extends StatefulWidget {
  final String businessType;
  final String? businessName;
  final String? businessAddress;
  final String? taxCode;
  final String? businessRegisterPhoto;
  final Function({
    required String businessType,
    String? businessName,
    String? businessAddress,
    String? taxCode,
    String? businessRegisterPhoto,
  }) onNext;
  final VoidCallback onBack;

  const TaxInfoStep({
    super.key,
    required this.businessType,
    this.businessName,
    this.businessAddress,
    this.taxCode,
    this.businessRegisterPhoto,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<TaxInfoStep> createState() => _TaxInfoStepState();
}

class _TaxInfoStepState extends State<TaxInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late String _businessType;
  late TextEditingController _businessNameController;
  late TextEditingController _businessAddressController;
  late TextEditingController _taxCodeController;
  String? _businessRegisterPhotoPath;

  @override
  void initState() {
    super.initState();
    _businessType = widget.businessType;
    _businessNameController = TextEditingController(text: widget.businessName);
    _businessAddressController = TextEditingController(text: widget.businessAddress);
    _taxCodeController = TextEditingController(text: widget.taxCode);
    _businessRegisterPhotoPath = widget.businessRegisterPhoto;
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _taxCodeController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      widget.onNext(
        businessType: _businessType,
        businessName: _businessNameController.text,
        businessAddress: _businessAddressController.text,
        taxCode: _taxCodeController.text,
        businessRegisterPhoto: _businessRegisterPhotoPath,
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
            BusinessTypeSelector(
              label: 'Business Type',
              selectedType: _businessType,
              onChanged: (type) {
                setState(() {
                  _businessType = type;
                });
              },
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: 'Business Name',
              placeholder: 'Enter business name',
              controller: _businessNameController,
              validator: (value) => _validateRequired(value, 'Business name'),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: 'Business Address',
              placeholder: 'Enter business address',
              controller: _businessAddressController,
              validator: (value) => _validateRequired(value, 'Business address'),
              maxLines: 3,
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: 'Tax Code',
              placeholder: 'Enter tax code',
              controller: _taxCodeController,
              validator: (value) => _validateRequired(value, 'Tax code'),
            ),
            SizedBox(height: 20.h),
            ImagePickerField(
              title: 'Business Register Photo',
              imagePath: _businessRegisterPhotoPath,
              onImageSelected: (path) {
                setState(() {
                  _businessRegisterPhotoPath = path;
                });
              },
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
                    onPressed: _handleNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Next',
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
