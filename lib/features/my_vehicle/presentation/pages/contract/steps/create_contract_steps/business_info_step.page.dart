import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/image_picker_field.widget.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/business_type_selector.widget.dart';

class BusinessInfoStep extends StatefulWidget {
  final String businessType;
  final String? businessName;
  final String? businessProvince;
  final String? businessAddress;
  final String? taxCode;
  final String? businessRegisterPhoto;
  final String? notes;
  final Function({
    required String businessType,
    String? businessName,
    String? businessProvince,
    String? businessAddress,
    String? taxCode,
    String? businessRegisterPhoto,
    String? notes,
  })
  onNext;
  final VoidCallback onBack;

  const BusinessInfoStep({
    super.key,
    required this.businessType,
    this.businessName,
    this.businessProvince,
    this.businessAddress,
    this.taxCode,
    this.businessRegisterPhoto,
    this.notes,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<BusinessInfoStep> createState() => _BusinessInfoStepState();
}

class _BusinessInfoStepState extends State<BusinessInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late String _businessType;
  late TextEditingController _businessNameController;
  late TextEditingController _businessProvinceController;
  late TextEditingController _businessAddressController;
  late TextEditingController _taxCodeController;
  late TextEditingController _notesController;
  String? _businessRegisterPhotoPath;

  @override
  void initState() {
    super.initState();
    _businessType = widget.businessType;
    _businessNameController = TextEditingController(text: widget.businessName);
    _businessProvinceController = TextEditingController(
      text: widget.businessProvince,
    );
    _businessAddressController = TextEditingController(
      text: widget.businessAddress,
    );
    _taxCodeController = TextEditingController(text: widget.taxCode);
    _notesController = TextEditingController(text: widget.notes);
    _businessRegisterPhotoPath = widget.businessRegisterPhoto;
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessProvinceController.dispose();
    _businessAddressController.dispose();
    _taxCodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired(fieldName);
    }
    return null;
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      widget.onNext(
        businessType: _businessType,
        businessName: _businessNameController.text,
        businessProvince: _businessProvinceController.text,
        businessAddress: _businessAddressController.text,
        taxCode: _taxCodeController.text,
        businessRegisterPhoto: _businessRegisterPhotoPath,
        notes: _notesController.text,
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
              label: AppLocalizations.of(context)!.businessType,
              selectedType: _businessType,
              onChanged: (type) {
                setState(() {
                  _businessType = type;
                });
              },
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.businessName,
              placeholder: AppLocalizations.of(context)!.enterBusinessName,
              controller: _businessNameController,
              validator:
                  (value) => _validateRequired(
                    value,
                    AppLocalizations.of(context)!.businessName,
                  ),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.province,
              placeholder: AppLocalizations.of(context)!.searchProvinceHint,
              controller: _businessProvinceController,
              validator:
                  (value) => _validateRequired(
                    value,
                    AppLocalizations.of(context)!.province,
                  ),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.businessAddress,
              placeholder: AppLocalizations.of(context)!.enterBusinessAddress,
              controller: _businessAddressController,
              validator:
                  (value) => _validateRequired(
                    value,
                    AppLocalizations.of(context)!.businessAddress,
                  ),
              maxLines: 3,
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.taxCode,
              placeholder: AppLocalizations.of(context)!.enterTaxCode,
              controller: _taxCodeController,
              validator:
                  (value) => _validateRequired(
                    value,
                    AppLocalizations.of(context)!.taxCode,
                  ),
            ),
            SizedBox(height: 20.h),
            ImagePickerField(
              title: AppLocalizations.of(context)!.businessRegisterPhoto,
              imagePath: _businessRegisterPhotoPath,
              onImageSelected: (path) {
                setState(() {
                  _businessRegisterPhotoPath = path;
                });
              },
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.notes,
              placeholder: AppLocalizations.of(context)!.note,
              controller: _notesController,
              maxLines: 4,
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
                      AppLocalizations.of(context)!.back,
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
                      AppLocalizations.of(context)!.next,
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
