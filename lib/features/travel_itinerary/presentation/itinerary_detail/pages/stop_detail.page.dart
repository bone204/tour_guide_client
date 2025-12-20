import 'dart:async';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/pages/stop_media.page.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/get_stop_detail/get_stop_detail_cubit.dart';

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
          title:
              _currentStop.destination?.name ??
              AppLocalizations.of(context)!.unknown,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
    final List<String> allImages = [
      if (_currentStop.destination?.photos != null)
        ..._currentStop.destination!.photos!,
      ..._currentStop.images,
    ];
    final List<String> allVideos = [
      if (_currentStop.destination?.videos != null)
        ..._currentStop.destination!.videos!,
      ..._currentStop.videos,
    ];

    return Row(
      children: [
        Expanded(
          child: _buildCreativeMediaButton(
            context,
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
          child: _buildCreativeMediaButton(
            context,
            title: AppLocalizations.of(context)!.videos,
            count: allVideos.length,
            icon: Icons.play_circle_outline,
            imageUrl: allImages.isNotEmpty ? allImages.last : null,
            color: Colors.orangeAccent,
            onTap: () => _openVideoGallery(context),
          ),
        ),
      ],
    );
  }

  Widget _buildCreativeMediaButton(
    BuildContext context, {
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? imageUrl,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image with Blur
              if (imageUrl != null) Image.network(imageUrl, fit: BoxFit.cover),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
              // Content
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Icon(icon, color: Colors.white, size: 24.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      title,
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Colors.white),
                    ),
                    Text(
                      '$count items',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openGallery(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRouteConstant.stopMedia,
      arguments: {
        'stop': _currentStop,
        'initialType': MediaType.image,
        'itineraryId': widget.itineraryId,
      },
    );
  }

  void _openVideoGallery(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRouteConstant.stopMedia,
      arguments: {
        'stop': _currentStop,
        'initialType': MediaType.video,
        'itineraryId': widget.itineraryId,
      },
    );
  }
}
