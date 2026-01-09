import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/profile/presentation/widgets/profile_image_thumbnail.dart';

class CitizenImagesSection extends StatelessWidget {
  final String? frontImageUrl;

  const CitizenImagesSection({
    Key? key,
    required this.frontImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.images,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        SizedBox(height: 6.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            border: Border.all(color: AppColors.secondaryGrey, width: 1.w),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: ProfileImageThumbnail(
            label: AppLocalizations.of(context)!.citizenFront,
            imageUrl: frontImageUrl,
            onTap: () {
              if (frontImageUrl != null) {
                _showImageDialog(context, frontImageUrl!);
              }
            },
          ),
        ),
      ],
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                InteractiveViewer(
                  // Allow zooming
                  child: Image.network(imageUrl),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
