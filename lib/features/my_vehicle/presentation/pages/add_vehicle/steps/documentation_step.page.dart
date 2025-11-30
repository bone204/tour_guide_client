import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/image_picker_field.widget.dart';

class DocumentationStep extends StatefulWidget {
  final String? registrationFrontPhoto;
  final String? registrationBackPhoto;
  final Function({
    String? registrationFrontPhoto,
    String? registrationBackPhoto,
  }) onNext;
  final VoidCallback onBack;

  const DocumentationStep({
    super.key,
    this.registrationFrontPhoto,
    this.registrationBackPhoto,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<DocumentationStep> createState() => _DocumentationStepState();
}

class _DocumentationStepState extends State<DocumentationStep> {
  String? _frontPhotoPath;
  String? _backPhotoPath;

  @override
  void initState() {
    super.initState();
    _frontPhotoPath = widget.registrationFrontPhoto;
    _backPhotoPath = widget.registrationBackPhoto;
  }

  void _handleNext() {
    widget.onNext(
      registrationFrontPhoto: _frontPhotoPath,
      registrationBackPhoto: _backPhotoPath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ImagePickerField(
            title: AppLocalizations.of(context)!.vehicleRegistrationFrontPhoto,
            imagePath: _frontPhotoPath,
            onImageSelected: (path) {
              setState(() {
                _frontPhotoPath = path;
              });
            },
          ),
          SizedBox(height: 20.h),
          ImagePickerField(
            title: AppLocalizations.of(context)!.vehicleRegistrationBackPhoto,
            imagePath: _backPhotoPath,
            onImageSelected: (path) {
              setState(() {
                _backPhotoPath = path;
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
    );
  }
}

