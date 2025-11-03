import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/constants/app_default_image.constant.dart';

class PhotosTab extends StatelessWidget {
  final List<String>? photos;
  final String? defaultImage;

  const PhotosTab({
    super.key,
    this.photos,
    this.defaultImage,
  });

  void _showPhotoViewer(BuildContext context, int initialIndex) {
    if (photos == null || photos!.isEmpty) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewerPage(
          photos: photos!,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

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
            childAspectRatio: 1,
          ),
          itemCount: hasPhotos ? photos!.length : 1,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: hasPhotos ? () => _showPhotoViewer(context, index) : null,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: hasPhotos
                    ? Image.network(
                        photos![index],
                        fit: BoxFit.cover,
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
                      ),
              ),
            );
          },
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}

// Photo Viewer Full Screen Page
class PhotoViewerPage extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;

  const PhotoViewerPage({
    super.key,
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<PhotoViewerPage> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<PhotoViewerPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: Stack(
        children: [
          // PageView for swiping photos
          PageView.builder(
            controller: _pageController,
            itemCount: widget.photos.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    widget.photos[index],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppColors.primaryWhite,
                            size: 64.r,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Failed to load image',
                            style: TextStyle(color: AppColors.primaryWhite),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),

          // Top controls
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlack.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColors.primaryWhite,
                        size: 24.r,
                      ),
                    ),
                  ),

                  // Photo counter
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlack.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${widget.photos.length}',
                      style: TextStyle(
                        color: AppColors.primaryWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

