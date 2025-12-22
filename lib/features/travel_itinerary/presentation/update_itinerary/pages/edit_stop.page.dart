import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/events/app_events.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/destination/data/models/destination.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/stops.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/edit_stop/edit_stop_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/edit_stop/edit_stop_state.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/delete_stop/delete_stop_cubit.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/delete_stop/delete_stop_state.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';

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

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.stop.notes);
    _startTimeController = TextEditingController(text: widget.stop.startTime);
    _endTimeController = TextEditingController(text: widget.stop.endTime);
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<EditStopCubit>()),
        BlocProvider(create: (context) => sl<DeleteStopCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<EditStopCubit, EditStopState>(
            listener: (context, state) {
              if (state is EditStopSuccess) {
                eventBus.fire(StopAddedEvent()); // Trigger refresh
                Navigator.pop(context, true);
              } else if (state is EditStopFailure) {
                CustomSnackbar.show(
                  context,
                  message: state.message,
                  type: SnackbarType.error,
                );
              }
            },
          ),
          BlocListener<DeleteStopCubit, DeleteStopState>(
            listener: (context, state) {
              if (state is DeleteStopSuccess) {
                eventBus.fire(StopAddedEvent()); // Trigger refresh
                Navigator.pop(context, true);
              } else if (state is DeleteStopFailure) {
                CustomSnackbar.show(
                  context,
                  message: state.message,
                  type: SnackbarType.error,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<EditStopCubit, EditStopState>(
          builder: (context, editState) {
            return BlocBuilder<DeleteStopCubit, DeleteStopState>(
              builder: (context, deleteState) {
                final isLoading =
                    editState is EditStopLoading ||
                    deleteState is DeleteStopLoading;
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Scaffold(
                        appBar: CustomAppBar(
                          title: AppLocalizations.of(context)!.editStop,
                          showBackButton: true,
                          onBackPressed: () => Navigator.pop(context),
                          actions: [
                            Builder(
                              builder: (context) {
                                return IconButton(
                                  onPressed:
                                      () => _showDeleteValidationDialog(
                                        context,
                                        widget.stop.id,
                                      ),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        body: SingleChildScrollView(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.stop.destination?.name ??
                                    AppLocalizations.of(context)!.unknown,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              if (widget.stop.destination?.descriptionViet !=
                                      null ||
                                  widget.stop.destination?.descriptionEng !=
                                      null) ...[
                                SizedBox(height: 12.h),
                                _buildDetailsSection(
                                  context,
                                  widget.stop.destination!,
                                ),
                                SizedBox(height: 12.h),
                              ],
                              SizedBox(height: 12.h),
                              if (widget.stop.destination?.photos?.isNotEmpty ==
                                  true)
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
                                              AppLocalizations.of(
                                                context,
                                              )!.startTime,
                                          placeholder: '',
                                          controller: _startTimeController,
                                          suffixIcon: const Icon(
                                            Icons.access_time,
                                          ),
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
                                              AppLocalizations.of(
                                                context,
                                              )!.endTime,
                                          placeholder: '',
                                          controller: _endTimeController,
                                          suffixIcon: const Icon(
                                            Icons.access_time,
                                          ),
                                        ),
                                      ),
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
                                title:
                                    AppLocalizations.of(context)!.saveChanges,
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
            );
          },
        ),
      ),
    );
  }

  void _showDeleteValidationDialog(BuildContext context, int stopId) {
    final deleteStopCubit = context.read<DeleteStopCubit>();
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.deleteStopConfirmTitle),
            content: Text(
              AppLocalizations.of(context)!.deleteStopConfirmMessage,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: TextStyle(color: AppColors.secondaryGrey),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  deleteStopCubit.deleteStop(widget.itineraryId, stopId);
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

  @override
  void dispose() {
    _notesController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();

    super.dispose();
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
