import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_detail/widgets/itinerary_detail_shimmer.widget.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/itinerary_explore_detail/itinerary_explore_detail_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/itinerary_explore_detail/itinerary_explore_detail_state.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/use_itinerary_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/use_itinerary/use_itinerary_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/bloc/use_itinerary/use_itinerary_state.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/widgets/explore_timeline.widget.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/itinerary_explore/widgets/itinerary_date_picker.dart';

class ItineraryExploreDetailPage extends StatelessWidget {
  final int itineraryId;

  const ItineraryExploreDetailPage({super.key, required this.itineraryId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  sl<ItineraryExploreDetailCubit>()
                    ..getItineraryDetail(itineraryId),
        ),
        BlocProvider(create: (context) => sl<UseItineraryCubit>()),
      ],
      child: const _ItineraryExploreDetailView(),
    );
  }
}

class _ItineraryExploreDetailView extends StatelessWidget {
  const _ItineraryExploreDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UseItineraryCubit, UseItineraryState>(
      listener: (context, state) {
        if (state is UseItinerarySuccess) {
          // Reset to home/main
          Navigator.of(context).popUntil((route) => route.isFirst);
          // Push My Itinerary Page
          Navigator.of(context).pushNamed(AppRouteConstant.myItinerary);
          // Push Itinerary List Page immediately
          Navigator.of(context).pushNamed(AppRouteConstant.itineraryList);

          CustomSnackbar.show(
            context,
            message: AppLocalizations.of(context)!.useItinerarySuccess,
            type: SnackbarType.success,
          );
        } else if (state is UseItineraryFailure) {
          Navigator.of(context).pop(); // Pop dialog
          CustomSnackbar.show(
            context,
            message: state.message,
            type: SnackbarType.error,
          );
        } else if (state is UseItineraryLoading) {
          // Optional: Show loading overlay
        }
      },
      child: BlocConsumer<
        ItineraryExploreDetailCubit,
        ItineraryExploreDetailState
      >(
        listener: (context, state) {
          if (state is ItineraryExploreDetailFailure) {
            CustomSnackbar.show(
              context,
              message: state.message,
              type: SnackbarType.error,
            );
          }
        },
        builder: (context, state) {
          if (state is ItineraryExploreDetailLoading) {
            return const ItineraryDetailShimmer();
          } else if (state is ItineraryExploreDetailSuccess) {
            final itinerary = state.itinerary;
            final title = itinerary.name;
            final defaultImage =
                'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=2073&auto=format&fit=crop';
            final List<String> images = [];
            if (itinerary.stops.isNotEmpty) {
              for (var stop in itinerary.stops) {
                if (stop.destination != null &&
                    stop.destination!.photos != null &&
                    stop.destination!.photos!.isNotEmpty) {
                  images.add(stop.destination!.photos!.first);
                }
              }
            }
            final List<Map<String, dynamic>> days =
                itinerary.stops
                    .map(
                      (stop) => <String, dynamic>{
                        'day': AppLocalizations.of(
                          context,
                        )!.dayNumber(stop.dayOrder > 0 ? stop.dayOrder : 1),
                        'activity': stop.destination!.name,
                        'time': stop.startTime,
                        'stop': stop,
                      },
                    )
                    .toList();

            return Scaffold(
              backgroundColor: AppColors.backgroundColor,
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  final useItineraryCubit = context.read<UseItineraryCubit>();
                  showDialog(
                    context: context,
                    builder:
                        (dialogContext) => BlocProvider.value(
                          value: useItineraryCubit,
                          child: _UseItineraryDialog(itinerary: itinerary),
                        ),
                  );
                },
                backgroundColor: AppColors.primaryBlue,
                icon: const Icon(Icons.copy_rounded, color: Colors.white),
                label: Text(
                  AppLocalizations.of(context)!.useItinerary,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              body: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: 250.h,
                    pinned: true,
                    backgroundColor: AppColors.backgroundColor,
                    leading: Padding(
                      padding: EdgeInsets.only(
                        left: 16.w,
                        top: 8.h,
                        bottom: 8.h,
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            AppIcons.arrowLeft,
                            width: 16.w,
                            height: 16.h,
                            colorFilter: const ColorFilter.mode(
                              AppColors.primaryBlack,
                              BlendMode.srcIn,
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (images.isNotEmpty)
                            CarouselSlider(
                              options: CarouselOptions(
                                height: double.infinity,
                                viewportFraction: 1.0,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 5),
                                autoPlayAnimationDuration: const Duration(
                                  seconds: 1,
                                ),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                scrollDirection: Axis.horizontal,
                              ),
                              items:
                                  images.map((imgUrl) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Image.network(
                                          imgUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(color: Colors.grey),
                                        );
                                      },
                                    );
                                  }).toList(),
                            )
                          else
                            Image.network(
                              defaultImage,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      Container(color: Colors.grey),
                            ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20.h,
                            left: 20.w,
                            right: 20.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 4.h,
                                  ),
                                  margin: EdgeInsets.only(bottom: 8.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    itinerary.province,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                                Text(
                                  title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: Colors.white),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (days.isNotEmpty) ...[
                            Text(
                              AppLocalizations.of(context)!.itinerarySchedule,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: AppColors.textPrimary),
                            ),
                            SizedBox(height: 16.h),
                            ExploreTimeline(timelineItems: days),
                          ] else
                            Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Lottie.asset(
                                    AppLotties.empty,
                                    width: 300.w,
                                    height: 300.h,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.image_not_supported,
                                        size: 64.sp,
                                        color: AppColors.primaryGrey,
                                      );
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 30.w,
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.noSchedule,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 80.h), // Added extra space for FAB
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _UseItineraryDialog extends StatefulWidget {
  final Itinerary itinerary;

  const _UseItineraryDialog({required this.itinerary});

  @override
  State<_UseItineraryDialog> createState() => _UseItineraryDialogState();
}

class _UseItineraryDialogState extends State<_UseItineraryDialog> {
  late TextEditingController _nameController;
  DateTime? _startDate;
  DateTime? _endDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.itinerary.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primaryWhite,
      title: Text(AppLocalizations.of(context)!.useItinerary),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _nameController,
                label: AppLocalizations.of(context)!.enterItineraryName,
                placeholder: '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.nameRequired;
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),
              ItineraryDatePicker(
                label: AppLocalizations.of(context)!.startDate,
                placeholder: 'dd/mm/yyyy',
                initialDate: _startDate,
                firstDate: DateTime.now().add(const Duration(days: 1)),
                onChanged: (date) {
                  setState(() {
                    _startDate = date;
                    // Reset end date if it's before new start date
                    if (_endDate != null && _endDate!.isBefore(_startDate!)) {
                      _endDate = null;
                    }
                  });
                },
              ),
              SizedBox(height: 16.h),
              ItineraryDatePicker(
                label: AppLocalizations.of(context)!.endDate,
                placeholder: 'dd/mm/yyyy',
                initialDate: _endDate,
                firstDate:
                    _startDate ?? DateTime.now().add(const Duration(days: 1)),
                onChanged: (date) {
                  setState(() {
                    _endDate = date;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: const TextStyle(color: AppColors.textSubtitle),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (_startDate == null || _endDate == null) {
                CustomSnackbar.show(
                  context,
                  message: AppLocalizations.of(context)!.dateRequired,
                  type: SnackbarType.error,
                );
                return;
              }
              final request = UseItineraryRequest(
                name: _nameController.text,
                startDate: _startDate!.toIso8601String(),
                endDate: _endDate!.toIso8601String(),
              );
              context.read<UseItineraryCubit>().useItinerary(
                widget.itinerary.id,
                request,
              );
              Navigator.of(context).pop();
            }
          },
          child: BlocBuilder<UseItineraryCubit, UseItineraryState>(
            builder: (context, state) {
              if (state is UseItineraryLoading) {
                return SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                );
              }
              return Text(
                AppLocalizations.of(context)!.confirm,
                style: const TextStyle(color: AppColors.primaryBlue),
              );
            },
          ),
        ),
      ],
    );
  }
}
