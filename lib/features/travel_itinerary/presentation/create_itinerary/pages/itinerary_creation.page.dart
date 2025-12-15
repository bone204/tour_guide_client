import 'package:intl/intl.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/dialog/custom_dialog.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/travel_itinerary.dart';

class ItineraryCreationPage extends StatefulWidget {
  final String province;
  final List<Destination> selectedDestinations;

  const ItineraryCreationPage({
    super.key,
    required this.province,
    required this.selectedDestinations,
  });

  @override
  State<ItineraryCreationPage> createState() => _ItineraryCreationPageState();
}

class _ItineraryCreationPageState extends State<ItineraryCreationPage> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  int _numberOfDays = 1;

  // Map day number to list of destinations
  Map<int, List<Destination>> _dayDestinations = {};

  @override
  void initState() {
    super.initState();
    _titleController.text = AppLocalizations.of(
      context,
    )!.itineraryCreationTitle(widget.province);
    // Initialize with default dates
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final dayAfterTomorrow = DateTime.now().add(const Duration(days: 2));

    _startDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    _endDate = DateTime(
      dayAfterTomorrow.year,
      dayAfterTomorrow.month,
      dayAfterTomorrow.day,
    );

    // Calculate number of days correctly (inclusive)
    _numberOfDays = _endDate!.difference(_startDate!).inDays + 1;

    // Initialize day destinations
    _initializeDayDestinations();
  }

  void _initializeDayDestinations() {
    _dayDestinations = {};
    for (int i = 1; i <= _numberOfDays; i++) {
      _dayDestinations[i] = [];
    }
    // Add all destinations to day 1 by default
    if (widget.selectedDestinations.isNotEmpty) {
      _dayDestinations[1] = List.from(widget.selectedDestinations);
    }
  }

  void _updateNumberOfDays() {
    if (_startDate != null && _endDate != null) {
      final days = _endDate!.difference(_startDate!).inDays + 1;
      if (days != _numberOfDays) {
        setState(() {
          _numberOfDays = days;
          // Preserve existing assignments, add empty lists for new days
          for (int i = 1; i <= _numberOfDays; i++) {
            _dayDestinations.putIfAbsent(i, () => []);
          }
          // Remove days beyond the new number
          _dayDestinations.removeWhere((key, value) => key > _numberOfDays);
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.createItinerary,
        showBackButton: true,
        onBackPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildBasicInfo(),
                  _buildDateSelection(),
                  _buildDayPlanning(),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryBlue, AppColors.primaryLightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.edit_calendar_rounded,
                  color: AppColors.primaryWhite,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.arrangeItinerary,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primaryWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16.sp,
                          color: AppColors.primaryWhite.withOpacity(0.9),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.placesCount(widget.selectedDestinations.length),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryWhite.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Icon(
                          Icons.calendar_today,
                          size: 16.sp,
                          color: AppColors.primaryWhite.withOpacity(0.9),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.daysCount(_numberOfDays),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryWhite.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit_note_rounded,
                size: 22.sp,
                color: AppColors.primaryBlue,
              ),
              SizedBox(width: 8.w),
              Text(
                AppLocalizations.of(context)!.itineraryName,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _titleController,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.itineraryHint,
              hintStyle: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
              prefixIcon: Icon(
                Icons.title_rounded,
                color: AppColors.textSubtitle,
                size: 20.sp,
              ),
              filled: true,
              fillColor: AppColors.backgroundColor,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.secondaryGrey.withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.secondaryGrey.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(
                  color: AppColors.primaryBlue,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.date_range_rounded,
                size: 22.sp,
                color: AppColors.primaryBlue,
              ),
              SizedBox(width: 8.w),
              Text(
                AppLocalizations.of(context)!.tripDuration,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildDatePicker(
                  label: AppLocalizations.of(context)!.startDate,
                  date: _startDate,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() {
                        _startDate = picked;
                        if (_endDate != null &&
                            _endDate!.isBefore(_startDate!)) {
                          _endDate = _startDate;
                        }
                        _updateNumberOfDays();
                      });
                    }
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildDatePicker(
                  label: AppLocalizations.of(context)!.endDate,
                  date: _endDate,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _endDate ?? _startDate ?? DateTime.now(),
                      firstDate: _startDate ?? DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() {
                        _endDate = picked;
                        _updateNumberOfDays();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryBlue.withOpacity(0.1),
                  AppColors.primaryLightBlue.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.primaryBlue.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_available_rounded,
                  size: 24.sp,
                  color: AppColors.primaryBlue,
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.totalDuration,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.daysCount(_numberOfDays),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.secondaryGrey.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSubtitle),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 16.sp,
                  color: AppColors.primaryBlue,
                ),
                SizedBox(width: 8.w),
                Text(
                  date != null
                      ? DateFormat('dd/MM/yyyy').format(date)
                      : 'Chọn ngày',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayPlanning() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 80.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.view_day_rounded,
                size: 22.sp,
                color: AppColors.primaryBlue,
              ),
              SizedBox(width: 8.w),
              Text(
                AppLocalizations.of(context)!.arrangePlacesByDay,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            AppLocalizations.of(context)!.arrangePlacesByDayDesc,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSubtitle),
          ),
          SizedBox(height: 16.h),
          ...List.generate(_numberOfDays, (index) {
            final dayNumber = index + 1;
            final dayDestinations = _dayDestinations[dayNumber] ?? [];
            final dayDate = _startDate?.add(Duration(days: index));

            return _DayPlanningCard(
              dayNumber: dayNumber,
              date: dayDate,
              destinations: dayDestinations,
              allDestinations: widget.selectedDestinations,
              onDestinationsChanged: (newDestinations) {
                setState(() {
                  _dayDestinations[dayNumber] = newDestinations;
                });
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final isValid =
        _titleController.text.isNotEmpty &&
        _startDate != null &&
        _endDate != null;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isValid ? _handleCreateItinerary : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              disabledBackgroundColor: AppColors.secondaryGrey,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.completeItinerary,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.primaryWhite,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleCreateItinerary() {
    // Create itinerary days
    final days = <ItineraryDay>[];
    for (int i = 1; i <= _numberOfDays; i++) {
      final dayDate = _startDate!.add(Duration(days: i - 1));
      final destinations = _dayDestinations[i] ?? [];
      days.add(
        ItineraryDay(
          dayNumber: i,
          date: DateFormat('yyyy-MM-dd').format(dayDate),
          destinations: destinations,
        ),
      );
    }

    // Show success dialog
    showAppDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      iconWidget: Icon(
        Icons.check_circle_rounded,
        size: 64.sp,
        color: AppColors.primaryGreen,
      ),
      titleWidget: Text(
        AppLocalizations.of(context)!.createItinerarySuccess,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
      contentWidget: Text(
        AppLocalizations.of(context)!.createItinerarySuccessMessage,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: CrossAxisAlignment.end,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: Text(
            AppLocalizations.of(context)!.close,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _DayPlanningCard extends StatelessWidget {
  const _DayPlanningCard({
    required this.dayNumber,
    required this.date,
    required this.destinations,
    required this.allDestinations,
    required this.onDestinationsChanged,
  });

  final int dayNumber;
  final DateTime? date;
  final List<Destination> destinations;
  final List<Destination> allDestinations;
  final Function(List<Destination>) onDestinationsChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.all(16.w),
          childrenPadding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: 16.h,
          ),
          leading: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$dayNumber',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          title: Text(
            AppLocalizations.of(context)!.dayNumber(dayNumber),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            date != null
                ? DateFormat('dd/MM/yyyy').format(date!)
                : AppLocalizations.of(context)!.noDateSelected,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSubtitle),
          ),
          trailing: Text(
            AppLocalizations.of(context)!.placesCount(destinations.length),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            if (destinations.isEmpty)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  AppLocalizations.of(context)!.noPlacesAdded,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSubtitle,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...destinations.asMap().entries.map((entry) {
                final index = entry.key;
                final destination = entry.value;
                return _DestinationItem(
                  destination: destination,
                  order: index + 1,
                  onRemove: () {
                    final newList = List<Destination>.from(destinations);
                    newList.removeAt(index);
                    onDestinationsChanged(newList);
                  },
                );
              }),
            SizedBox(height: 8.h),
            OutlinedButton.icon(
              onPressed: () => _showAddDestinationDialog(context),
              icon: const Icon(Icons.add_rounded),
              label: Text(AppLocalizations.of(context)!.addLocation),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
                side: const BorderSide(color: AppColors.primaryBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDestinationDialog(BuildContext context) {
    // ✅ Get destinations not yet added to this day (chỉ địa điểm chưa có trong ngày này)
    final availableDestinations =
        allDestinations
            .where((d) => !destinations.any((dest) => dest.id == d.id))
            .toList();

    if (availableDestinations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(AppLocalizations.of(context)!.allLocationsAdded),
              ),
            ],
          ),
          backgroundColor: AppColors.primaryOrange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    showAppDialog<void>(
      context: context,
      useRootNavigator: true,
      titleWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add_location_rounded,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.addLocation,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.dayNumber(dayNumber),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.primaryBlue,
                ),
                const SizedBox(width: 6),
                Text(
                  AppLocalizations.of(context)!.placesNotAdded(availableDestinations.length),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      contentWidget: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: availableDestinations.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, index) {
            final dest = availableDestinations[index];
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  final newList = List<Destination>.from(destinations);
                  newList.add(dest);
                  onDestinationsChanged(newList);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.secondaryGrey.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.place,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dest.name,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (dest.specificAddress != null &&
                                dest.specificAddress!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                dest.specificAddress!,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.textSubtitle),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.add_circle_outline,
                        color: AppColors.primaryBlue,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      actionsAlignment: CrossAxisAlignment.end,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(
            'Đóng',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textSubtitle,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _DestinationItem extends StatelessWidget {
  const _DestinationItem({
    required this.destination,
    required this.order,
    required this.onRemove,
  });

  final Destination destination;
  final int order;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Order badge with gradient
          Container(
            width: 48.w,
            height: 48.w,
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.primaryLightBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$order',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16.sp,
                        color: AppColors.primaryBlue,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          destination.name,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (destination.specificAddress != null &&
                      destination.specificAddress!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 14.sp,
                          color: AppColors.textSubtitle,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            destination.specificAddress!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSubtitle),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (destination.rating != null) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 14.sp,
                          color: AppColors.primaryYellow,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          destination.rating!.toStringAsFixed(1),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Remove button
          Container(
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline_rounded),
              color: AppColors.primaryRed,
              iconSize: 20.sp,
              padding: EdgeInsets.all(8.w),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
