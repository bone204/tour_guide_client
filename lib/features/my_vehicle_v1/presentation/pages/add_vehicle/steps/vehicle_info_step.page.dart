import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/my_vehicle_v1/presentation/widgets/vehicle_type_selector.widget.dart';

class VehicleInfoStep extends StatefulWidget {
  final String licensePlate;
  final String vehicleRegistration;
  final String vehicleType;
  final String vehicleBrand;
  final String vehicleModel;
  final String vehicleColor;
  final Function({
    required String licensePlate,
    required String vehicleRegistration,
    required String vehicleType,
    required String vehicleBrand,
    required String vehicleModel,
    required String vehicleColor,
  })
  onNext;

  const VehicleInfoStep({
    super.key,
    required this.licensePlate,
    required this.vehicleRegistration,
    required this.vehicleType,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.onNext,
  });

  @override
  State<VehicleInfoStep> createState() => _VehicleInfoStepState();
}

class _VehicleInfoStepState extends State<VehicleInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late String _vehicleType;
  late TextEditingController _licensePlateController;
  late TextEditingController _vehicleRegistrationController;
  late TextEditingController _vehicleBrandController;
  late TextEditingController _vehicleModelController;
  late TextEditingController _vehicleColorController;

  @override
  void initState() {
    super.initState();
    _vehicleType = widget.vehicleType.isEmpty ? 'car' : widget.vehicleType;
    _licensePlateController = TextEditingController(text: widget.licensePlate);
    _vehicleRegistrationController = TextEditingController(
      text: widget.vehicleRegistration,
    );
    _vehicleBrandController = TextEditingController(text: widget.vehicleBrand);
    _vehicleModelController = TextEditingController(text: widget.vehicleModel);
    _vehicleColorController = TextEditingController(text: widget.vehicleColor);
  }

  @override
  void dispose() {
    _licensePlateController.dispose();
    _vehicleRegistrationController.dispose();
    _vehicleBrandController.dispose();
    _vehicleModelController.dispose();
    _vehicleColorController.dispose();
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
        licensePlate: _licensePlateController.text,
        vehicleRegistration: _vehicleRegistrationController.text,
        vehicleType: _vehicleType,
        vehicleBrand: _vehicleBrandController.text,
        vehicleModel: _vehicleModelController.text,
        vehicleColor: _vehicleColorController.text,
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
            VehicleTypeSelector(
              label: AppLocalizations.of(context)!.vehicleType,
              selectedType: _vehicleType,
              onChanged: (type) {
                setState(() {
                  _vehicleType = type;
                });
              },
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.licensePlate,
              placeholder: AppLocalizations.of(context)!.exampleLicensePlate,
              controller: _licensePlateController,
              validator:
                  (value) => _validateRequired(
                    value,
                    AppLocalizations.of(context)!.licensePlate,
                  ),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.vehicleRegistrationNumber,
              placeholder:
                  AppLocalizations.of(context)!.enterRegistrationNumber,
              controller: _vehicleRegistrationController,
              validator:
                  (value) => _validateRequired(
                    value,
                    AppLocalizations.of(context)!.vehicleRegistrationNumber,
                  ),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.vehicleBrand,
              placeholder: AppLocalizations.of(context)!.exampleBrand,
              controller: _vehicleBrandController,
              validator:
                  (value) => _validateRequired(
                    value,
                    AppLocalizations.of(context)!.vehicleBrand,
                  ),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.vehicleModel,
              placeholder: AppLocalizations.of(context)!.exampleModel,
              controller: _vehicleModelController,
              validator:
                  (value) => _validateRequired(
                    value,
                    AppLocalizations.of(context)!.vehicleModel,
                  ),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.vehicleColor,
              placeholder: AppLocalizations.of(context)!.exampleColor,
              controller: _vehicleColorController,
              validator:
                  (value) => _validateRequired(
                    value,
                    AppLocalizations.of(context)!.vehicleColor,
                  ),
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
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
          ],
        ),
      ),
    );
  }
}
