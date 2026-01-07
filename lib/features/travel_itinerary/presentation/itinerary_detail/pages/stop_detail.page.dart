import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/get_stop_detail/get_stop_detail_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/checkin_stop/checkin_stop_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/bloc/checkin_stop/checkin_stop_state.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/widgets/creative_media_button.dart';
import 'package:tour_guide_app/core/events/app_events.dart';

class StopDetailPage extends StatefulWidget {
  final Stop stop;
  final int itineraryId;
  final String itineraryStatus;

  const StopDetailPage({
    super.key,
    required this.stop,
    required this.itineraryId,
    required this.itineraryStatus,
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

  bool _isWithinTimeWindow() {
    try {
      final now = DateTime.now();
      final startTime = _parseTime(_currentStop.startTime);
      final endTime = _parseTime(_currentStop.endTime);

      if (startTime == null || endTime == null) return false;

      return now.isAfter(startTime) && now.isBefore(endTime);
    } catch (e) {
      return false;
    }
  }

  DateTime? _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return null;

      final now = DateTime.now();
      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    } catch (e) {
      return null;
    }
  }

  bool _shouldShowCheckInButton() {
    return widget.itineraryStatus == 'in_progress' &&
        _currentStop.status != 'completed' &&
        _isWithinTimeWindow();
  }

  Future<void> _handleCheckIn() async {
    try {
      // Show loading message
      CustomSnackbar.show(
        context,
        message: AppLocalizations.of(context)!.gettingLocation,
        type: SnackbarType.info,
      );

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        context.read<CheckInStopCubit>().checkIn(
          itineraryId: widget.itineraryId,
          stopId: _currentStop.id,
          latitude: position.latitude,
          longitude: position.longitude,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(
          context,
          message: e.toString(),
          type: SnackbarType.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetStopDetailCubit, GetStopDetailState>(
          listener: (context, state) {
            if (state is GetStopDetailSuccess) {
              setState(() {
                _currentStop = state.stop;
              });
            }
          },
        ),
        BlocListener<CheckInStopCubit, CheckInStopState>(
          listener: (context, state) {
            if (state is CheckInStopSuccess) {
              CustomSnackbar.show(
                context,
                message: AppLocalizations.of(context)!.checkInSuccess,
                type: SnackbarType.success,
              );
              // Fire event to refresh itinerary detail
              eventBus.fire(
                CheckInSuccessEvent(
                  itineraryId: widget.itineraryId,
                  stopId: widget.stop.id,
                ),
              );
              // Navigate back after short delay
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  Navigator.pop(context);
                }
              });
            } else if (state is CheckInStopFailure) {
              CustomSnackbar.show(
                context,
                message:
                    '${AppLocalizations.of(context)!.checkInFailed}: ${state.message}',
                type: SnackbarType.error,
              );
            }
          },
        ),
      ],
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

              // Check-in Button
              if (_shouldShowCheckInButton())
                BlocBuilder<CheckInStopCubit, CheckInStopState>(
                  builder: (context, state) {
                    final isLoading = state is CheckInStopLoading;
                    return PrimaryButton(
                      title: AppLocalizations.of(context)!.checkInHere,
                      onPressed: isLoading ? null : _handleCheckIn,
                      isLoading: isLoading,
                    );
                  },
                ),
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
