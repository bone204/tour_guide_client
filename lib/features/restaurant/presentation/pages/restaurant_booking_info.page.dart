import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_table.dart';
import 'package:tour_guide_app/features/restaurant/data/models/create_restaurant_booking_request.dart';
import 'package:tour_guide_app/features/restaurant/presentation/bloc/create_restaurant_booking/create_restaurant_booking_cubit.dart';
import 'package:tour_guide_app/features/restaurant/presentation/bloc/create_restaurant_booking/create_restaurant_booking_state.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:intl/intl.dart';

class RestaurantBookingInfoPage extends StatefulWidget {
  final Cooperation restaurant;
  final DateTime checkInTime;
  final List<Map<String, dynamic>> selectedTables;
  final int? numberOfGuests;

  const RestaurantBookingInfoPage({
    super.key,
    required this.restaurant,
    required this.checkInTime,
    required this.selectedTables,
    this.numberOfGuests,
  });

  @override
  State<RestaurantBookingInfoPage> createState() =>
      _RestaurantBookingInfoPageState();
}

class _RestaurantBookingInfoPageState extends State<RestaurantBookingInfoPage> {
  late CreateRestaurantBookingCubit _cubit;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _noteController = TextEditingController();
  final _timeController = TextEditingController();

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  List<Map<String, dynamic>> _currentSelectedTables = [];
  late int _numberOfGuests;

  @override
  void initState() {
    super.initState();
    _cubit = sl<CreateRestaurantBookingCubit>();
    _selectedDate = widget.checkInTime;
    _selectedTime = TimeOfDay.fromDateTime(widget.checkInTime);
    _currentSelectedTables = List.from(widget.selectedTables);
    _numberOfGuests = widget.numberOfGuests ?? 1;
    // TODO: Pre-fill name/phone from User Profile if available
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-fill time with current time or logic if needed
    _updateTimeText();
  }

  @override
  void dispose() {
    _cubit.close();
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _updateTimeText() {
    final dateStr = DateFormat('dd/MM/yyyy').format(_selectedDate);
    final timeStr = _selectedTime.format(context);
    _timeController.text = "$timeStr - $dateStr";
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (pickedDate != null) {
      if (!context.mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
          _updateTimeText();
        });
      }
    }
  }

  void _updateTableQuantity(int index, int change) {
    setState(() {
      final item = _currentSelectedTables[index];
      int newQty = (item['quantity'] as int) + change;
      if (newQty < 1) return; // Minimum 1
      item['quantity'] = newQty;
    });
  }

  Widget _buildCounterField(
    String label,
    int count,
    VoidCallback onIncrement,
    VoidCallback onDecrement,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.secondaryGrey, width: 1.w),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$count ${AppLocalizations.of(context)!.people}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: onDecrement,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryGrey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(
                        Icons.remove,
                        size: 18.sp,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  InkWell(
                    onTap: onIncrement,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 18.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmBooking() {
    if (_formKey.currentState!.validate()) {
      final bookingDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final formattedTime = DateFormat(
        'dd:MM:yyyy HH:mm',
      ).format(bookingDateTime);

      final List<int> tableIds = [];
      for (final item in _currentSelectedTables) {
        final table = item['table'] as RestaurantTable;
        final quantity = item['quantity'] as int;
        for (int i = 0; i < quantity; i++) {
          tableIds.add(table.id);
        }
      }

      final request = CreateRestaurantBookingRequest(
        tableIds: tableIds,
        checkInDate: formattedTime,
        contactName: _nameController.text,
        contactPhone: _phoneController.text,
        notes: _noteController.text.isNotEmpty ? _noteController.text : null,
        numberOfGuests: _numberOfGuests,
      );

      _cubit.createBooking(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => _cubit,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: CustomAppBar(
            title: AppLocalizations.of(context)!.tableBookingInfo,
            showBackButton: true,
            onBackPressed: () => Navigator.pop(context),
          ),
          body: BlocConsumer<
            CreateRestaurantBookingCubit,
            CreateRestaurantBookingState
          >(
            listener: (context, state) {
              if (state is CreateRestaurantBookingSuccess) {
                CustomSnackbar.show(
                  context,
                  message: AppLocalizations.of(context)!.tableBookingSuccess,
                  type: SnackbarType.success,
                );
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouteConstant.restaurantBillList,
                  (route) => route.settings.name == AppRouteConstant.mainScreen,
                );
                Navigator.of(context).pushNamed(
                  AppRouteConstant.restaurantBillDetail,
                  arguments: state.bookingId,
                );
              } else if (state is CreateRestaurantBookingFailure) {
                CustomSnackbar.show(
                  context,
                  message: state.message,
                  type: SnackbarType.error,
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 236.h,
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      child:
                          (widget.restaurant.photo != null &&
                                  widget.restaurant.photo!.isNotEmpty &&
                                  (widget.restaurant.photo!.startsWith(
                                        'http',
                                      ) ||
                                      widget.restaurant.photo!.startsWith(
                                        'https',
                                      )))
                              ? Image.network(
                                widget.restaurant.photo!,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Image.asset(
                                      AppImage.defaultFood,
                                      fit: BoxFit.cover,
                                    ),
                              )
                              : Image.asset(
                                AppImage.defaultFood,
                                fit: BoxFit.cover,
                              ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.restaurant.name,
                              style: theme.titleLarge,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              widget.restaurant.province ?? "",
                              style: theme.bodyMedium?.copyWith(
                                color: AppColors.textSubtitle,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Divider(height: 2.h, color: AppColors.primaryGrey),
                            SizedBox(height: 16.h),

                            // Contact Info
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.contactInfo, // Ensure key exists or use fallback
                              style: theme.titleMedium,
                            ),
                            SizedBox(height: 16.h),
                            CustomTextField(
                              controller: _nameController,
                              label: AppLocalizations.of(context)!.fullName,
                              placeholder:
                                  AppLocalizations.of(context)!.enterFullName,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(
                                    context,
                                  )!.pleaseEnterFullName;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),
                            CustomTextField(
                              controller: _phoneController,
                              label: AppLocalizations.of(context)!.phoneNumber,
                              placeholder:
                                  AppLocalizations.of(
                                    context,
                                  )!.enterPhoneNumber,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppLocalizations.of(
                                    context,
                                  )!.pleaseEnterPhoneNumber;
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 16.h),
                            CustomTextField(
                              controller: _timeController,
                              placeholder: AppLocalizations.of(context)!.time,
                              label: AppLocalizations.of(context)!.time,
                              readOnly: true,
                              onTap: () => _selectDateTime(context),
                            ),
                            SizedBox(height: 16.h),

                            // Number of Guests
                            _buildCounterField(
                              AppLocalizations.of(context)!.numberOfGuests,
                              _numberOfGuests,
                              () => setState(() => _numberOfGuests++),
                              () => setState(() {
                                if (_numberOfGuests > 1) _numberOfGuests--;
                              }),
                            ),

                            SizedBox(height: 16.h),
                            CustomTextField(
                              controller: _noteController,
                              label: AppLocalizations.of(context)!.note,
                              placeholder:
                                  AppLocalizations.of(context)!.enterNote,
                              maxLines: 3,
                            ),

                            SizedBox(height: 24.h),
                            Divider(height: 2.h, color: AppColors.primaryGrey),
                            SizedBox(height: 16.h),

                            // Booking Summary
                            // Selected Tables List
                            Text(
                              AppLocalizations.of(context)!.table,
                              style: theme.titleMedium,
                            ),
                            SizedBox(height: 8.h),
                            ..._currentSelectedTables.asMap().entries.map((
                              entry,
                            ) {
                              final index = entry.key;
                              final item = entry.value;
                              final table = item['table'] as RestaurantTable;
                              final quantity = item['quantity'] as int;

                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryWhite,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: AppColors.secondaryGrey,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        child: Image.asset(
                                          AppImage.defaultFood,
                                          width: 80.w,
                                          height: 80.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              table.name,
                                              style: theme.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w900,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              "${table.guests} ${AppLocalizations.of(context)!.people}",
                                              style: theme.bodySmall?.copyWith(
                                                color: AppColors.textSubtitle,
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap:
                                                      () =>
                                                          _updateTableQuantity(
                                                            index,
                                                            -1,
                                                          ),
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                      4.w,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .secondaryGrey
                                                          .withOpacity(0.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4.r,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      Icons.remove,
                                                      size: 16.sp,
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '$quantity',
                                                  style: theme.bodyMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                ),
                                                InkWell(
                                                  onTap:
                                                      () =>
                                                          _updateTableQuantity(
                                                            index,
                                                            1,
                                                          ),
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                      4.w,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppColors.primaryBlue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4.r,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 16.sp,
                                                      color:
                                                          AppColors
                                                              .primaryWhite,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),

                            SizedBox(height: 24.h),
                            PrimaryButton(
                              title:
                                  AppLocalizations.of(
                                    context,
                                  )!.confirmTableBooking,
                              isLoading:
                                  state is CreateRestaurantBookingLoading,
                              onPressed: _confirmBooking,
                              backgroundColor: AppColors.primaryBlue,
                              textColor: AppColors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
