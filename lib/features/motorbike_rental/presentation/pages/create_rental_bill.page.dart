import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tour_guide_app/common/constants/app_default_image.constant.dart';
import 'package:tour_guide_app/common/constants/app_route.constant.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';
import 'package:tour_guide_app/core/config/theme/color.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/motorbike_rental/data/models/create_rental_bill_request.dart';
import 'package:tour_guide_app/features/motorbike_rental/presentation/bloc/create_rental_bill/create_rental_bill_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/rental_vehicle.dart';
import 'package:tour_guide_app/service_locator.dart';

class CreateRentalBillPage extends StatefulWidget {
  final RentalVehicle vehicle;
  final String rentalType;
  final DateTime initialStartDate;

  const CreateRentalBillPage({
    super.key,
    required this.vehicle,
    required this.rentalType,
    required this.initialStartDate,
  });

  @override
  State<CreateRentalBillPage> createState() => _CreateRentalBillPageState();
}

class _CreateRentalBillPageState extends State<CreateRentalBillPage> {
  final TextEditingController _locationController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  late DateTime _startDate;
  late DateTime _endDate;
  String? _selectedPackage;
  List<Map<String, dynamic>> _packages = [];

  // Controllers for date fields
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _startDateController.text = _dateFormat.format(_startDate);
    // Packages generation depends on localization but strictly speaking the keys are hardcoded in logic for now.
    // We should re-generate packages on build or local change if we want localized labels.
    if (_packages.isEmpty) {
      _endDate = _startDate.add(const Duration(hours: 1));
      _endDateController.text = _dateFormat.format(_endDate);
    }
  }

  // Moved package generation to a helper that takes locale to localize labels
  void _generatePackages(AppLocalizations locale) {
    _packages.clear();
    final v = widget.vehicle;
    if (widget.rentalType == 'hourly') {
      if (v.priceFor4Hours != null) {
        _packages.add({
          'label': '4 ${locale.hour}',
          'value': '4h',
          'duration': const Duration(hours: 4),
          'price': v.priceFor4Hours,
        });
      }
      if (v.priceFor8Hours != null) {
        _packages.add({
          'label': '8 ${locale.hour}',
          'value': '8h',
          'duration': const Duration(hours: 8),
          'price': v.priceFor8Hours,
        });
      }
      if (v.priceFor12Hours != null) {
        _packages.add({
          'label': '12 ${locale.hour}',
          'value': '12h',
          'duration': const Duration(hours: 12),
          'price': v.priceFor12Hours,
        });
      }
    } else {
      if (v.priceFor2Days != null) {
        _packages.add({
          'label': '2 ${locale.day}',
          'value': '2d',
          'duration': const Duration(days: 2),
          'price': v.priceFor2Days,
        });
      }
      if (v.priceFor3Days != null) {
        _packages.add({
          'label': '3 ${locale.day}',
          'value': '3d',
          'duration': const Duration(days: 3),
          'price': v.priceFor3Days,
        });
      }
      if (v.priceFor5Days != null) {
        _packages.add({
          'label': '5 ${locale.day}',
          'value': '5d',
          'duration': const Duration(days: 5),
          'price': v.priceFor5Days,
        });
      }
      if (v.priceFor7Days != null) {
        _packages.add({
          'label': '7 ${locale.day}',
          'value': '7d',
          'duration': const Duration(days: 7),
          'price': v.priceFor7Days,
        });
      }
      _packages.insert(0, {
        'label': '1 ${locale.day}',
        'value': '1d',
        'duration': const Duration(days: 1),
        'price': v.pricePerDay,
      });
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateEndDate() {
    if (_selectedPackage == null) return;
    final package = _packages.firstWhere(
      (element) => element['value'] == _selectedPackage,
      orElse: () => _packages.first,
    );
    setState(() {
      _endDate = _startDate.add(package['duration'] as Duration);
      _endDateController.text = _dateFormat.format(_endDate);
    });
  }

  Future<void> _pickStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startDate),
      );
      if (time != null) {
        setState(() {
          _startDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          _startDateController.text = _dateFormat.format(_startDate);
          _updateEndDate();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    // Generate packages on build to ensure correct localization if lang changes,
    // but safeguard against resetting selection if possible.
    // For simplicity in this scope, we regenerate.
    _generatePackages(locale);

    // Ensure selection is valid
    if (_selectedPackage == null && _packages.isNotEmpty) {
      _selectedPackage = _packages.first['value'];
      _updateEndDate();
    }

    return BlocProvider(
      create: (context) => sl<CreateRentalBillCubit>(),
      child: BlocListener<CreateRentalBillCubit, CreateRentalBillState>(
        listener: (context, state) {
          if (state is CreateRentalBillSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(locale.rentalBillCreatedSuccess)),
            );
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouteConstant.rentalBillList,
              (route) => route.settings.name == AppRouteConstant.mainScreen,
            );
            Navigator.of(context).pushNamed(
              AppRouteConstant.rentalBillDetail,
              arguments: state.bill.id,
            );
          } else if (state is CreateRentalBillFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: CustomAppBar(
              title: locale.rentalInfo,
              showBackButton: true,
              onBackPressed: () => Navigator.pop(context),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVehicleInfo(context),
                  SizedBox(height: 20.h),
                  _buildRentalForm(context, locale),
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomBar(context, locale),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
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
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              color: AppColors.primaryGrey.withOpacity(0.2),
              child: Image.network(
                widget.vehicle.vehicleCatalog?.photo ?? '',
                width: 80.w,
                height: 80.w,
                fit: BoxFit.contain,
                errorBuilder:
                    (context, error, stackTrace) => Image.asset(
                      AppImage.defaultCar,
                      width: 80.w,
                      height: 80.w,
                    ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.vehicle.vehicleCatalog?.brand} ${widget.vehicle.vehicleCatalog?.model}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.vehicle.licensePlate,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRentalForm(BuildContext context, AppLocalizations locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${locale.rentalType}: ${widget.rentalType == 'HOURLY' ? locale.hourlyRent : locale.dailyRent}',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(height: 16.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.durationPackage,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 6.h),
            DropdownButtonFormField2<String>(
              value: _selectedPackage,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: AppColors.primaryWhite,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.secondaryGrey,
                    width: 1.w,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.secondaryGrey,
                    width: 1.w,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.primaryGrey,
                    width: 2.w,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              isExpanded: true,
              hint: Text(
                locale.pleaseSelectPackage,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textSubtitle),
              ),
              items:
                  _packages.map((pkg) {
                    final price = Formatter.currency(pkg['price'] ?? 0);
                    return DropdownMenuItem<String>(
                      value: pkg['value'],
                      child: Text(
                        '${pkg['label']} - $price',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPackage = value;
                  _updateEndDate();
                });
              },
              buttonStyleData: ButtonStyleData(
                height: 48.h,
                padding: EdgeInsets.only(right: 8.w),
              ),
              iconStyleData: IconStyleData(
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.black54,
                ),
                iconSize: 24.sp,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.primaryWhite,
                ),
              ),
              menuItemStyleData: MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: _pickStartDate,
          child: AbsorbPointer(
            child: CustomTextField(
              controller: _startDateController,
              label: locale.startDate,
              placeholder: 'DD/MM/YYYY HH:mm',
            ),
          ),
        ),
        SizedBox(height: 16.h),
        AbsorbPointer(
          child: CustomTextField(
            controller: _endDateController,
            label: locale.calculatedEndDate,
            placeholder: 'DD/MM/YYYY HH:mm',
          ),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          controller: _locationController,
          label: locale.location,
          placeholder: locale.enterPickupLocation,
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          controller: _notesController,
          label: locale.notes,
          placeholder: locale.notes,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, AppLocalizations locale) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (ctx) {
                final selectedPkg = _packages.firstWhere(
                  (e) => e['value'] == _selectedPackage,
                  orElse: () => {'price': 0},
                );
                final price = selectedPkg['price'] ?? 0;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${locale.totalPayment}:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      Formatter.currency(price),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16.h),
            BlocBuilder<CreateRentalBillCubit, CreateRentalBillState>(
              builder: (context, state) {
                return PrimaryButton(
                  title: locale.confirmRental,
                  isLoading: state is CreateRentalBillLoading,
                  onPressed:
                      _packages.isEmpty
                          ? null
                          : () {
                            if (_selectedPackage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(locale.pleaseSelectPackage),
                                ),
                              );
                              return;
                            }
                            final request = CreateRentalBillRequest(
                              rentalType: widget.rentalType,
                              vehicleType: 'bike',
                              durationPackage: _selectedPackage!,
                              startDate: _startDate,
                              endDate: _endDate,
                              location: _locationController.text,
                              details: [
                                RentalBillDetailRequest(
                                  licensePlate: widget.vehicle.licensePlate,
                                  note: _notesController.text,
                                ),
                              ],
                            );
                            context
                                .read<CreateRentalBillCubit>()
                                .createRentalBill(request);
                          },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
