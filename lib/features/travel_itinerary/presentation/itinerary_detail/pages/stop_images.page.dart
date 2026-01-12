import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/stop_media/stop_media_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/stop_media/stop_media_state.dart';
import 'package:tour_guide_app/service_locator.dart';

import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/core/events/app_events.dart' as app_events;

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
                    app_events.eventBus.fire(
                      app_events.StopUpdatedEvent(widget.stop.id),
                    );
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
                                  AppLocalizations.of(context)!.noPhotosYet,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                SizedBox(height: 24.h),
                                PrimaryButton(
                                  onPressed: () => _pickImages(context),
                                  title:
                                      AppLocalizations.of(context)!.addPhotos,
                                  width: 200.w,
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
                      return Builder(
                        builder: (context) {
                          return GestureDetector(
                            onTap:
                                () => _openFullScreenImage(
                                  context,
                                  images,
                                  index,
                                ),
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
                                          AppLocalizations.of(context)!.delete,
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
                                  _confirmDelete(context, images[index]);
                                }
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(
                                images[index],
                                fit: BoxFit.cover,
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
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

  void _confirmDelete(BuildContext context, String imageUrl) {
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
                    images: [imageUrl],
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
