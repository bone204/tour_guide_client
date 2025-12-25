import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tour_guide_app/common_libs.dart';

import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/image_picker_field.widget.dart';

class DocumentationStep extends StatefulWidget {
  final XFile? registrationFront;
  final XFile? registrationBack;
  final Function({XFile? registrationFront, XFile? registrationBack}) onNext;
  final VoidCallback onBack;

  const DocumentationStep({
    super.key,
    this.registrationFront,
    this.registrationBack,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<DocumentationStep> createState() => _DocumentationStepState();
}

class _DocumentationStepState extends State<DocumentationStep> {
  XFile? _registrationFront;
  XFile? _registrationBack;

  @override
  void initState() {
    super.initState();
    _registrationFront = widget.registrationFront;
    _registrationBack = widget.registrationBack;
  }

  void _handleNext() {
    // Optionally validate images here
    widget.onNext(
      registrationFront: _registrationFront,
      registrationBack: _registrationBack,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16.h),
        ImagePickerField(
          title: locale.vehicleRegistrationFrontPhoto,
          imagePath: _registrationFront?.path,
          onImageSelected: (path) {
            setState(
              () => _registrationFront = path != null ? XFile(path) : null,
            );
          },
        ),
        SizedBox(height: 16.h),
        ImagePickerField(
          title: locale.vehicleRegistrationBackPhoto,
          imagePath: _registrationBack?.path,
          onImageSelected: (path) {
            setState(
              () => _registrationBack = path != null ? XFile(path) : null,
            );
          },
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
                onPressed: _handleNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  locale.continueText,
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
    );
  }
}
