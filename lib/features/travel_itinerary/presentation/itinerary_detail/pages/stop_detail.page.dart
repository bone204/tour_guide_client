import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/get_stop_detail/get_stop_detail_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/widgets/creative_media_button.dart';
import 'package:tour_guide_app/core/events/app_events.dart';

class StopDetailPage extends StatefulWidget {
  final Stop stop;
  final int itineraryId;

  const StopDetailPage({
    super.key,
    required this.stop,
    required this.itineraryId,
  });

  @override
  State<StopDetailPage> createState() => _StopDetailPageState();
}

class _StopDetailPageState extends State<StopDetailPage> {
  late Stop _currentStop;
  late StreamSubscription _updateSubscription;

  @override
  void initState() {
    super.initState();
    _currentStop = widget.stop;
    _updateSubscription = eventBus.on<StopUpdatedEvent>().listen((event) {
      if (event.stopId == _currentStop.id) {
        context.read<GetStopDetailCubit>().getStopDetail(
          widget.itineraryId,
          _currentStop.id,
        );
      }
    });
  }

  @override
  void dispose() {
    _updateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetStopDetailCubit, GetStopDetailState>(
      listener: (context, state) {
        if (state is GetStopDetailSuccess) {
          setState(() {
            _currentStop = state.stop;
          });
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.stopDetail,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentStop.destination?.name ??
                    AppLocalizations.of(context)!.unknown,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: AppColors.textPrimary),
              ),
              SizedBox(height: 12.h),
              // Description
              if (_currentStop.destination?.descriptionViet != null ||
                  _currentStop.destination?.descriptionEng != null) ...[
                _buildDetailsSection(context, _currentStop.destination!),
                SizedBox(height: 12.h),
              ],
              SizedBox(height: 12.h),

              // Media Section
              _buildMediaSection(context),
              SizedBox(height: 24.h),

              // Time Selection (Read-only)
              Row(
                children: [
                  Expanded(
                    child: _buildReadOnlyField(
                      context,
                      AppLocalizations.of(context)!.startTime,
                      _currentStop.startTime,
                      Icons.access_time,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _buildReadOnlyField(
                      context,
                      AppLocalizations.of(context)!.endTime,
                      _currentStop.endTime,
                      Icons.access_time,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Notes (Read-only)
              _buildReadOnlyField(
                context,
                AppLocalizations.of(context)!.note,
                _currentStop.notes,
                null,
                maxLines: 3,
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context, Destination destination) {
    final description =
        destination.descriptionViet ?? destination.descriptionEng;
    if (description == null || description.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(
      description,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.textPrimary,
        height: 1.5,
      ),
    );
  }

  Widget _buildReadOnlyField(
    BuildContext context,
    String label,
    String value,
    IconData? icon, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value.isNotEmpty ? value : '--',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null) ...[
                SizedBox(width: 8.w),
                Icon(icon, color: AppColors.textSecondary, size: 20.sp),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMediaSection(BuildContext context) {
    // Collect images and videos
    final List<String> allImages = _currentStop.images;
    final List<String> allVideos = _currentStop.videos;

    return Row(
      children: [
        Expanded(
          child: CreativeMediaButton(
            title: AppLocalizations.of(context)!.photos,
            count: allImages.length,
            icon: Icons.photo_library_outlined,
            imageUrl: allImages.isNotEmpty ? allImages.first : null,
            color: Colors.blueAccent,
            onTap: () => _openGallery(context),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: CreativeMediaButton(
            title: AppLocalizations.of(context)!.videos,
            count: allVideos.length,
            icon: Icons.play_circle_outline,
            videoUrl: allVideos.isNotEmpty ? allVideos.first : null,
            color: Colors.orangeAccent,
            onTap: () => _openVideoGallery(context),
          ),
        ),
      ],
    );
  }

  void _openGallery(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRouteConstant.stopImages,
      arguments: {'stop': _currentStop, 'itineraryId': widget.itineraryId},
    );
  }

  void _openVideoGallery(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRouteConstant.stopVideos,
      arguments: {'stop': _currentStop, 'itineraryId': widget.itineraryId},
    );
  }
}
