import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/stop_media/stop_media_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/stop_media/stop_media_state.dart';
import 'package:tour_guide_app/service_locator.dart';

import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';

class StopImagesPage extends StatefulWidget {
  final Stop stop;
  final int itineraryId;

  const StopImagesPage({
    super.key,
    required this.stop,
    required this.itineraryId,
  });

  @override
  State<StopImagesPage> createState() => _StopImagesPageState();
}

class _StopImagesPageState extends State<StopImagesPage> {
  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => sl<StopMediaCubit>()..init(widget.stop, MediaType.image),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.photos,
          onBackPressed: () => Navigator.pop(context),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.add_photo_alternate),
                  onPressed: () => _pickImages(context),
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

                  final images = context.read<StopMediaCubit>().media;
                  if (images.isEmpty) {
                    return CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_library_outlined,
                                  size: 64.sp,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  AppLocalizations.of(context)!.noPhotosYet,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                                SizedBox(height: 24.h),
                                ElevatedButton.icon(
                                  onPressed: () => _pickImages(context),
                                  icon: const Icon(Icons.add),
                                  label: Text(
                                    AppLocalizations.of(context)!.addPhotos,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return MasonryGridView.count(
                    physics: const AlwaysScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.h,
                    crossAxisSpacing: 8.w,
                    padding: EdgeInsets.all(16.w),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap:
                            () => _openFullScreenImage(context, images, index),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            images[index],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return _buildShimmerItem();
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Icon(Icons.error));
                            },
                          ),
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

  Future<void> _pickImages(BuildContext context) async {
    if (_isPicking) return;
    setState(() {
      _isPicking = true;
    });

    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty && context.mounted) {
        context.read<StopMediaCubit>().uploadMedia(
          itineraryId: widget.itineraryId,
          stopId: widget.stop.id,
          imagePaths: pickedFiles.map((e) => e.path).toList(),
        );
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  void _openFullScreenImage(
    BuildContext context,
    List<String> images,
    int index,
  ) {
    // Implement full screen image view if needed, or use a package like photo_view
    // For now, we can just show a dialog or simple page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: Center(child: Image.network(images[index])),
            ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8.h,
      crossAxisSpacing: 8.w,
      padding: EdgeInsets.all(16.w),
      itemCount: 6,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: AspectRatio(
            aspectRatio: (index % 2 + 1) / 1,
            child: _buildShimmerItem(),
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
}
