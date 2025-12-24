import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tour_guide_app/common_libs.dart';

class ImagePickerField extends StatefulWidget {
  final String title;
  final String? imagePath;
  final Function(String?) onImageSelected;

  const ImagePickerField({
    super.key,
    required this.title,
    this.imagePath,
    required this.onImageSelected,
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        widget.onImageSelected(image.path);
      }
    } catch (e) {
      // Handle error
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.displayLarge),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 180.h,
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.secondaryGrey, width: 1.5.w),
            ),
            child:
                widget.imagePath != null && widget.imagePath!.isNotEmpty
                    ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.file(
                            File(widget.imagePath!),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: GestureDetector(
                            onTap: () => widget.onImageSelected(null),
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: AppColors.primaryRed.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: AppColors.primaryWhite,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 48.sp,
                          color: AppColors.primaryGrey,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Tap to add image',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSubtitle),
                        ),
                      ],
                    ),
          ),
        ),
      ],
    );
  }
}
