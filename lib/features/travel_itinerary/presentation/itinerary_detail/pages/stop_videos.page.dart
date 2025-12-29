import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/stop_media/stop_media_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/stop_media/stop_media_state.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:shimmer/shimmer.dart';

import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';

class StopVideosPage extends StatefulWidget {
  final Stop stop;
  final int itineraryId;

  const StopVideosPage({
    super.key,
    required this.stop,
    required this.itineraryId,
  });

  @override
  State<StopVideosPage> createState() => _StopVideosPageState();
}

class _StopVideosPageState extends State<StopVideosPage> {
  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => sl<StopMediaCubit>()..init(widget.stop, MediaType.video),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.videos,
          onBackPressed: () => Navigator.pop(context),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.video_call),
                  onPressed: () => _pickVideo(context),
                );
              },
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            return RefreshIndicator(
              onRefresh:
                  () => context.read<StopMediaCubit>().loadStop(
                    widget.itineraryId,
                    widget.stop.id,
                  ),
              child: BlocConsumer<StopMediaCubit, StopMediaState>(
                listener: (context, state) {
                  if (state is StopMediaFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  } else if (state is StopMediaUploaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(
                            context,
                          )!.mediaUpdatedSuccessfully,
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is StopMediaLoading) {
                    return _buildShimmerLoading();
                  }

                  final videos = context.read<StopMediaCubit>().media;
                  if (videos.isEmpty) {
                    return CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    AppLotties.empty,
                                    width: 300.w,
                                    height: 200.h,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    AppLocalizations.of(context)!.noVideosYet,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  SizedBox(height: 24.h),
                                  PrimaryButton(
                                    onPressed: () => _pickVideo(context),
                                    title:
                                        AppLocalizations.of(context)!.addVideo,
                                    width: 200.w,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16.w),
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Builder(
                          builder: (context) {
                            return GestureDetector(
                              onLongPress: () {
                                final RenderBox box =
                                    context.findRenderObject() as RenderBox;
                                final Offset position = box.localToGlobal(
                                  Offset.zero,
                                );

                                showMenu(
                                  context: context,
                                  position: RelativeRect.fromLTRB(
                                    position.dx,
                                    position.dy,
                                    position.dx + box.size.width,
                                    position.dy + box.size.height,
                                  ),
                                  items: [
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.delete,
                                            style: const TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ).then((value) {
                                  if (value == 'delete') {
                                    _confirmDelete(context, videos[index]);
                                  }
                                });
                              },
                              child: VideoListItem(url: videos[index]),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickVideo(BuildContext context) async {
    if (_isPicking) return;
    setState(() {
      _isPicking = true;
    });

    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
      if (pickedFile != null && context.mounted) {
        context.read<StopMediaCubit>().uploadMedia(
          itineraryId: widget.itineraryId,
          stopId: widget.stop.id,
          videoPaths: [pickedFile.path],
        );
      }
    } catch (e) {
      debugPrint('Error picking video: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Container(
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.black12,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: _buildShimmerItem(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(color: Colors.white),
    );
  }

  void _confirmDelete(BuildContext context, String videoUrl) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.confirmDelete),
            content: Text(AppLocalizations.of(context)!.confirmDeleteContent),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.read<StopMediaCubit>().deleteMedia(
                    itineraryId: widget.itineraryId,
                    stopId: widget.stop.id,
                    videos: [videoUrl],
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.delete,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
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
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    );

    try {
      await _videoPlayerController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        placeholder: Container(color: Colors.black),
        autoInitialize: true,
      );
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.black12,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(color: Colors.white),
          ),
        ),
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
