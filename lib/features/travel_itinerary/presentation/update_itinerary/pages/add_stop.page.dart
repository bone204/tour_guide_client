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

class AddStopPage extends StatefulWidget {
  final int itineraryId;
  final Destination destination;

  const AddStopPage({
    super.key,
    required this.itineraryId,
    required this.destination,
  });

  @override
  State<AddStopPage> createState() => _AddStopPageState();
}

class _AddStopPageState extends State<AddStopPage> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _travelPointsController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-populate logic if needed
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
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
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
                    title: 'Add Stop',
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
                        SizedBox(height: 8.h),
                        Text(
                          widget.destination.specificAddress ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 24.h),
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
                                    label: 'Start Time',
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
                                    label: 'End Time',
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
                          label: 'Travel Points',
                          placeholder: 'Enter points',
                          controller: _travelPointsController,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16.h),

                        CustomTextField(
                          label: 'Notes',
                          placeholder: 'Add notes here...',
                          controller: _notesController,
                          maxLines: 3,
                        ),
                        SizedBox(height: 32.h),

                        PrimaryButton(
                          title: 'Add Stop',
                          onPressed: () {
                            final request = AddStopRequest(
                              dayOrder: 1, // TOD: Add Day selection logic
                              travelPoints:
                                  int.tryParse(_travelPointsController.text) ??
                                  0,
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
    _travelPointsController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }
}
