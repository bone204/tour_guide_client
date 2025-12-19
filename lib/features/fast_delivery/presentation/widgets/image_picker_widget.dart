import 'dart:io';
import 'package:tour_guide_app/common_libs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';

class ImagePickerWidget extends StatelessWidget {
  final List<String> images;
  final Function(List<String>) onImagesChanged;

  const ImagePickerWidget({
    super.key,
    required this.images,
    required this.onImagesChanged,
  });

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        final updatedImages = [...images, pickedFile.path];
        onImagesChanged(updatedImages);
      }
    } catch (e) {
      CustomSnackbar.show(
        context,
        message: AppLocalizations.of(
          context,
        )!.errorSelectingImage(e.toString()),
        type: SnackbarType.error,
      );
    }
  }

  void _removeImage(int index) {
    final updatedImages = [...images];
    updatedImages.removeAt(index);
    onImagesChanged(updatedImages);
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryGrey,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                AppLocalizations.of(context)!.selectPackageImage,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.primaryBlue),
                title: Text(AppLocalizations.of(context)!.takePhoto),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: AppColors.primaryBlue,
                ),
                title: Text(AppLocalizations.of(context)!.selectFromGallery),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.packageImages,
          style: theme.displayLarge,
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            // Display selected images
            ...images.asMap().entries.map((entry) {
              final index = entry.key;
              final imagePath = entry.value;
              return Stack(
                children: [
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppColors.secondaryGrey,
                        width: 1.w,
                      ),
                      image: DecorationImage(
                        image: FileImage(File(imagePath)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4.h,
                    right: 4.w,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: AppColors.textSecondary,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),

            // Add image button
            GestureDetector(
              onTap: () => _showImageSourceDialog(context),
              child: Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColors.primaryBlue,
                    width: 2.w,
                    style: BorderStyle.solid,
                  ),
                  color: AppColors.primaryBlue.withOpacity(0.05),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      color: AppColors.primaryBlue,
                      size: 32.sp,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      AppLocalizations.of(context)!.addImage,
                      style: theme.bodySmall?.copyWith(
                        color: AppColors.primaryBlue,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
