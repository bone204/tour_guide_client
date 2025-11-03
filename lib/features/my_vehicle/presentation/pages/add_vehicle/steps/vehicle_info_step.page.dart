import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/vehicle_type_selector.widget.dart';

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
  }) onNext;

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
    _vehicleRegistrationController = TextEditingController(text: widget.vehicleRegistration);
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
      return '$fieldName is required';
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
              label: 'Vehicle Type',
              selectedType: _vehicleType,
              onChanged: (type) {
                setState(() {
                  _vehicleType = type;
                });
              },
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: 'License Plate',
              placeholder: 'e.g. 51F-12345',
              controller: _licensePlateController,
              validator: (value) => _validateRequired(value, 'License plate'),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: 'Vehicle Registration Number',
              placeholder: 'Enter registration number',
              controller: _vehicleRegistrationController,
              validator: (value) => _validateRequired(value, 'Registration number'),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: 'Vehicle Brand',
              placeholder: 'e.g. Honda, Toyota',
              controller: _vehicleBrandController,
              validator: (value) => _validateRequired(value, 'Vehicle brand'),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: 'Vehicle Model',
              placeholder: 'e.g. City, Wave',
              controller: _vehicleModelController,
              validator: (value) => _validateRequired(value, 'Vehicle model'),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: 'Vehicle Color',
              placeholder: 'e.g. Black, White',
              controller: _vehicleColorController,
              validator: (value) => _validateRequired(value, 'Vehicle color'),
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
                'Next',
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

