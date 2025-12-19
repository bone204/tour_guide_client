import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/add_stop_request.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/add_stop/add_stop_cubit.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';

class AddStopPage extends StatefulWidget {
  final int itineraryId;
  final Destination destination;
  final int? dayOrder;

  const AddStopPage({
    super.key,
    required this.itineraryId,
    required this.destination,
    this.dayOrder,
  });

  @override
  State<AddStopPage> createState() => _AddStopPageState();
}

class _AddStopPageState extends State<AddStopPage> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      controller.text = '$hour:$minute';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddStopCubit>(),
      child: BlocConsumer<AddStopCubit, AddStopState>(
        listener: (context, state) {
          if (state is AddStopSuccess) {
            eventBus.fire(StopAddedEvent());
            Navigator.pop(context, state.stop);
          } else if (state is AddStopFailure) {
            CustomSnackbar.show(
              context,
              message: state.message,
              type: SnackbarType.error,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AddStopLoading;

          return Stack(
            children: [
              GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                  appBar: CustomAppBar(
                    title: AppLocalizations.of(context)!.addStop,
                    showBackButton: true,
                    onBackPressed: () => Navigator.pop(context),
                  ),
                  body: SingleChildScrollView(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.destination.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        if (widget.destination.descriptionViet != null ||
                            widget.destination.descriptionEng != null) ...[
                          SizedBox(height: 12.h),
                          _buildDetailsSection(context, widget.destination),
                          SizedBox(height: 12.h),
                        ],
                        SizedBox(height: 12.h),
                        Container(
                          height: 200.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.destination.photos!.first,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),
                        _buildNumberDisplay(
                          context,
                          label: AppLocalizations.of(context)!.day,
                          value: '${widget.dayOrder ?? 1}',
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap:
                                    () => _selectTime(
                                      context,
                                      _startTimeController,
                                    ),
                                child: AbsorbPointer(
                                  child: CustomTextField(
                                    label:
                                        AppLocalizations.of(context)!.startTime,
                                    placeholder: '08:00',
                                    controller: _startTimeController,
                                    suffixIcon: const Icon(Icons.access_time),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: GestureDetector(
                                onTap:
                                    () => _selectTime(
                                      context,
                                      _endTimeController,
                                    ),
                                child: AbsorbPointer(
                                  child: CustomTextField(
                                    label:
                                        AppLocalizations.of(context)!.endTime,
                                    placeholder: '10:00',
                                    controller: _endTimeController,
                                    suffixIcon: const Icon(Icons.access_time),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        CustomTextField(
                          label: AppLocalizations.of(context)!.note,
                          placeholder:
                              AppLocalizations.of(context)!.addNotesHint,
                          controller: _notesController,
                          maxLines: 3,
                        ),
                        SizedBox(height: 32.h),

                        PrimaryButton(
                          title: AppLocalizations.of(context)!.addStop,
                          onPressed: () {
                            if (_startTimeController.text.isEmpty ||
                                _endTimeController.text.isEmpty) {
                              CustomSnackbar.show(
                                context,
                                message:
                                    AppLocalizations.of(
                                      context,
                                    )!.selectStartEndTimeError,
                                type: SnackbarType.warning,
                              );
                              return;
                            }
                            final request = AddStopRequest(
                              dayOrder: widget.dayOrder ?? 1,
                              travelPoints: 0,
                              startTime: _startTimeController.text,
                              endTime: _endTimeController.text,
                              notes: _notesController.text,
                              destinationId: widget.destination.id,
                            );
                            context.read<AddStopCubit>().addStop(
                              widget.itineraryId,
                              request,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  Widget _buildNumberDisplay(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.displayLarge),
        SizedBox(height: 8.h),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.primaryBlue, width: 1.w),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: AppColors.primaryBlue,
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
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
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }
}
