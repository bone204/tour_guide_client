import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/stop_media/stop_media_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/stop_media/stop_media_state.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

enum MediaType { image, video }

class StopMediaPage extends StatefulWidget {
  final Stop stop;
  final MediaType initialType;
  final int itineraryId;

  const StopMediaPage({
    super.key,
    required this.stop,
    required this.initialType,
    required this.itineraryId,
  });

  @override
  State<StopMediaPage> createState() => _StopMediaPageState();
}

class _StopMediaPageState extends State<StopMediaPage> {
  late MediaType _currentType;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _currentType = widget.initialType;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              sl<StopMediaCubit>()
                ..loadStop(widget.itineraryId, widget.stop.id),
      child: BlocConsumer<StopMediaCubit, StopMediaState>(
        listener: (context, state) {
          if (state is StopMediaFailure) {
            CustomSnackbar.show(
              context,
              message: state.message,
              type: SnackbarType.error,
            );
          } else if (state is StopMediaUploaded) {
            CustomSnackbar.show(
              context,
              message: 'Media updated successfully',
              type: SnackbarType.success,
            );
            eventBus.fire(StopUpdatedEvent(state.stop.id));
          }
        },
        builder: (context, state) {
          Stop currentStop = widget.stop;
          if (state is StopMediaLoaded) {
            currentStop = state.stop;
          } else if (state is StopMediaUploaded) {
            currentStop = state.stop;
          }

          final List<String> images = [
            if (currentStop.destination?.photos != null)
              ...currentStop.destination!.photos!,
            ...currentStop.images,
          ];
          final List<String> videos = [
            if (currentStop.destination?.videos != null)
              ...currentStop.destination!.videos!,
            ...currentStop.videos,
          ];

          return Scaffold(
            appBar: CustomAppBar(
              title:
                  _currentType == MediaType.image
                      ? AppLocalizations.of(context)!.photos
                      : AppLocalizations.of(context)!.videos,
              showBackButton: true,
              onBackPressed: () => Navigator.pop(context),
            ),
            body: Column(
              children: [
                // Top Tab Selector
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTypeButton(
                          context,
                          MediaType.image,
                          'Photos (${images.length})',
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _buildTypeButton(
                          context,
                          MediaType.video,
                          'Videos (${videos.length})',
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child:
                      state is StopMediaLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _currentType == MediaType.image
                          ? _buildImageGrid(context, images)
                          : _buildVideoList(context, videos),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _pickMedia(context),
              icon: Icon(
                _currentType == MediaType.image
                    ? Icons.add_photo_alternate
                    : Icons.video_call,
              ),
              label: Text(
                _currentType == MediaType.image ? 'Add Photos' : 'Add Video',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeButton(BuildContext context, MediaType type, String label) {
    final isSelected = _currentType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentType = type;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primaryBlue
                  : AppColors.primaryGrey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context, List<String> images) {
    if (images.isEmpty) {
      return Center(child: Text('No photos yet'));
    }
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8.h,
      crossAxisSpacing: 8.w,
      padding: EdgeInsets.all(16.w),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _openFullScreenImage(context, images, index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.network(images[index], fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  Widget _buildVideoList(BuildContext context, List<String> videos) {
    if (videos.isEmpty) {
      return Center(child: Text('No videos yet'));
    }
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: VideoListItem(url: videos[index]),
        );
      },
    );
  }

  void _openFullScreenImage(
    BuildContext context,
    List<String> images,
    int initialIndex,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: PageView.builder(
                itemCount: images.length,
                controller: PageController(initialPage: initialIndex),
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    child: Center(
                      child: Image.network(images[index], fit: BoxFit.contain),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }

  Future<void> _pickMedia(BuildContext context) async {
    final cubit = context.read<StopMediaCubit>();
    if (_currentType == MediaType.image) {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        cubit.uploadMedia(
          itineraryId: widget.itineraryId,
          stopId: widget.stop.id,
          imagePaths: pickedFiles.map((e) => e.path).toList(),
        );
      }
    } else {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        cubit.uploadMedia(
          itineraryId: widget.itineraryId,
          stopId: widget.stop.id,
          videoPaths: [pickedFile.path],
        );
      }
    }
  }
}

class VideoListItem extends StatefulWidget {
  final String url;
  const VideoListItem({super.key, required this.url});

  @override
  State<VideoListItem> createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      );
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video player: $e');
      // You might want to set an error state here to show in the UI
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        height: 200.h,
        color: Colors.black12,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Chewie(controller: _chewieController!),
      ),
    );
  }
}
