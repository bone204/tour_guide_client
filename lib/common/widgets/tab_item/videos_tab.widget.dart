import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/constants/app_default_image.constant.dart';

class VideosTab extends StatelessWidget {
  final List<String>? photos;
  final String? defaultImage;

  const VideosTab({
    super.key,
    this.photos,
    this.defaultImage,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasPhotos = photos != null && photos!.isNotEmpty;
    final String fallbackImage = defaultImage ?? AppImage.defaultDestination;

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.75,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                // Background image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: hasPhotos
                      ? Image.network(
                          photos!.first,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            // Nếu network image lỗi, fallback sang asset image
                            return Image.asset(
                              fallbackImage,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          fallbackImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                ),
                // Play button overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: AppColors.primaryWhite.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 32.r,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ),
                ),
                // Duration badge
                Positioned(
                  bottom: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      '2:45',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primaryWhite,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}

