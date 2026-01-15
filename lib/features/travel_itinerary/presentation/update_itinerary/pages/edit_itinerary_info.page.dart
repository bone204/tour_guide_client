import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/itinerary.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/common/widgets/dialog/custom_dialog.dart';
import 'package:tour_guide_app/features/travel_itinerary/presentation/update_itinerary/bloc/update_itinerary_info/update_itinerary_info_cubit.dart';
import 'package:tour_guide_app/core/utils/date_formatter.dart';
import 'package:tour_guide_app/common/widgets/picker/date_picker.dart';
import 'package:tour_guide_app/core/events/app_events.dart';

class EditItineraryInfoPage extends StatefulWidget {
  final Itinerary itinerary;

  const EditItineraryInfoPage({super.key, required this.itinerary});

  @override
  State<EditItineraryInfoPage> createState() => _EditItineraryInfoPageState();
}

class _EditItineraryInfoPageState extends State<EditItineraryInfoPage> {
  late Itinerary _currentItinerary;
  late TextEditingController _nameController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _currentItinerary = widget.itinerary;
    _nameController = TextEditingController(text: _currentItinerary.name);

    // Correctly parse initial strings to DateTime then format
    _startDate = DateFormatter.parse(_currentItinerary.startDate);
    _endDate = DateFormatter.parse(_currentItinerary.endDate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final bool isNameChanged =
        _nameController.text.trim() != _currentItinerary.name;

    bool isDateChanged = false;
    // Compare dates
    if (_startDate != null) {
      final originalStart = DateFormatter.parse(_currentItinerary.startDate);
      // Simple compare on day level
      if (_startDate!.year != originalStart.year ||
          _startDate!.month != originalStart.month ||
          _startDate!.day != originalStart.day) {
        isDateChanged = true;
      }
    }
    if (_endDate != null) {
      final originalEnd = DateFormatter.parse(_currentItinerary.endDate);
      if (_endDate!.year != originalEnd.year ||
          _endDate!.month != originalEnd.month ||
          _endDate!.day != originalEnd.day) {
        isDateChanged = true;
      }
    }

    if (isNameChanged || isDateChanged) {
      final result = await showAppDialog<bool>(
        context: context,
        title: AppLocalizations.of(context)!.warning,
        content: AppLocalizations.of(context)!.discardChanges,
        actions: [
          PrimaryButton(
            title: AppLocalizations.of(context)!.confirm,
            onPressed: () => Navigator.pop(context, true),
          ),
          PrimaryButton(
            title: AppLocalizations.of(context)!.cancel,
            backgroundColor: Colors.white,
            textColor: AppColors.primaryBlue,
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      );
      return result ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UpdateItineraryInfoCubit>(),
      child: BlocListener<UpdateItineraryInfoCubit, UpdateItineraryInfoState>(
        listener: (context, state) {
          if (state is UpdateItineraryInfoSuccess) {
            CustomSnackbar.show(
              context,
              message: AppLocalizations.of(context)!.updateSuccess,
              type: SnackbarType.success,
            );
            eventBus.fire(ItineraryUpdatedEvent());
            Navigator.pop(context, true);
          } else if (state is UpdateItineraryInfoFailure) {
            CustomSnackbar.show(
              context,
              message: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              appBar: CustomAppBar(
                title: AppLocalizations.of(context)!.editItinerary,
                showBackButton: true,
                onBackPressed: () async {
                  if (await _onWillPop()) {
                    Navigator.pop(context);
                  }
                },
              ),
              body: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      placeholder: AppLocalizations.of(context)!.itineraryName,
                      label: AppLocalizations.of(context)!.itineraryName,
                    ),
                    SizedBox(height: 16.h),

                    DatePickerField(
                      label: AppLocalizations.of(context)!.startDate,
                      placeholder:
                          AppLocalizations.of(context)!.selectStartDate,
                      initialDate: _startDate,
                      onChanged: (date) {
                        setState(() {
                          _startDate = date;
                          // Auto adjust end date if it's before start date
                          if (_endDate != null &&
                              _endDate!.isBefore(_startDate!)) {
                            _endDate = null;
                          }
                        });
                      },
                    ),
                    SizedBox(height: 16.h),
                    DatePickerField(
                      key: ValueKey(_startDate),
                      label: AppLocalizations.of(context)!.endDate,
                      placeholder: AppLocalizations.of(context)!.selectEndDate,
                      initialDate: _endDate,
                      firstDate: _startDate,
                      onChanged: (date) {
                        setState(() {
                          _endDate = date;
                        });
                      },
                    ),
                    const Spacer(),
                    BlocBuilder<
                      UpdateItineraryInfoCubit,
                      UpdateItineraryInfoState
                    >(
                      builder: (context, state) {
                        return PrimaryButton(
                          title: AppLocalizations.of(context)!.update,
                          isLoading: state is UpdateItineraryInfoLoading,
                          onPressed: () {
                            if (_nameController.text.trim().isEmpty) {
                              CustomSnackbar.show(
                                context,
                                message:
                                    AppLocalizations.of(
                                      context,
                                    )!.requiredFields,
                                type: SnackbarType.error,
                              );
                              return;
                            }
                            if (_startDate == null || _endDate == null) {
                              CustomSnackbar.show(
                                context,
                                message:
                                    AppLocalizations.of(
                                      context,
                                    )!.requiredFields,
                                type: SnackbarType.error,
                              );
                              return;
                            }

                            if (_endDate!.isBefore(_startDate!)) {
                              CustomSnackbar.show(
                                context,
                                message:
                                    AppLocalizations.of(
                                      context,
                                    )!.endDateMustBeAfterStartDate,
                                type: SnackbarType.error,
                              );
                              return;
                            }

                            context
                                .read<UpdateItineraryInfoCubit>()
                                .updateItineraryInfo(
                                  id: _currentItinerary.id,
                                  name: _nameController.text.trim(),
                                  startDate: DateFormatter.formatDate(
                                    _startDate!,
                                  ),
                                  endDate: DateFormatter.formatDate(_endDate!),
                                );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
