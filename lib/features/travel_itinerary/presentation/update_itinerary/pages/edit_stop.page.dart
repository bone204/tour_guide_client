import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/edit_stop/edit_stop_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/edit_stop/edit_stop_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class EditStopPage extends StatefulWidget {
  final int itineraryId;
  final Stop stop;

  const EditStopPage({
    super.key,
    required this.itineraryId,
    required this.stop,
  });

  @override
  State<EditStopPage> createState() => _EditStopPageState();
}

class _EditStopPageState extends State<EditStopPage> {
  late TextEditingController _notesController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _dayOrderController;
  late TextEditingController _sequenceController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.stop.notes);
    _startTimeController = TextEditingController(text: widget.stop.startTime);
    _endTimeController = TextEditingController(text: widget.stop.endTime);
    _dayOrderController = TextEditingController(
      text: widget.stop.dayOrder.toString(),
    );
    _sequenceController = TextEditingController(
      text: widget.stop.sequence.toString(),
    );
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _parseTime(controller.text) ?? TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      controller.text = '$hour:$minute';
    }
  }

  TimeOfDay? _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EditStopCubit>(),
      child: BlocConsumer<EditStopCubit, EditStopState>(
        listener: (context, state) {
          if (state is EditStopSuccess) {
            eventBus.fire(StopAddedEvent()); // Trigger refresh
            Navigator.pop(context, true);
          } else if (state is EditStopFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is EditStopLoading;
          return Stack(
            children: [
              GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                  appBar: CustomAppBar(
                    title: AppLocalizations.of(context)!.editStop,
                    showBackButton: true,
                    onBackPressed: () => Navigator.pop(context),
                  ),
                  body: SingleChildScrollView(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stop.destination?.name ??
                              AppLocalizations.of(context)!.unknown,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 24.h),
                        if (widget.stop.destination?.photos?.isNotEmpty == true)
                          Container(
                            height: 200.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              image: DecorationImage(
                                image: NetworkImage(
                                  widget.stop.destination!.photos!.first,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        SizedBox(height: 24.h),

                        // Time Selection
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
                                    placeholder: '',
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
                                    placeholder: '',
                                    controller: _endTimeController,
                                    suffixIcon: const Icon(Icons.access_time),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Reorder Fields
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: AppLocalizations.of(context)!.dayOrder,
                                placeholder: '',
                                controller: _dayOrderController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: CustomTextField(
                                label: AppLocalizations.of(context)!.sequence,
                                placeholder: '',
                                controller: _sequenceController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Notes
                        CustomTextField(
                          label: AppLocalizations.of(context)!.note,
                          placeholder: '',
                          controller: _notesController,
                          maxLines: 3,
                        ),
                        SizedBox(height: 32.h),

                        PrimaryButton(
                          title: AppLocalizations.of(context)!.saveChanges,
                          onPressed: () {
                            if (_startTimeController.text.isEmpty ||
                                _endTimeController.text.isEmpty) {
                              // Validation
                              return;
                            }

                            context.read<EditStopCubit>().updateStop(
                              itineraryId: widget.itineraryId,
                              originalStop: widget.stop,
                              newStartTime: _startTimeController.text,
                              newEndTime: _endTimeController.text,
                              newNotes: _notesController.text,
                              newDayOrder: int.tryParse(
                                _dayOrderController.text,
                              ),
                              newSequence: int.tryParse(
                                _sequenceController.text,
                              ),
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
    _dayOrderController.dispose();
    _sequenceController.dispose();
    super.dispose();
  }
}
