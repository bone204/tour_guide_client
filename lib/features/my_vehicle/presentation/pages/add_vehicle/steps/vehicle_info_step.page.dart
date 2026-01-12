import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';
import 'package:tour_guide_app/common_libs.dart';

import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/vehicle_catalog.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/vehicle_type_selector.widget.dart';

class VehicleInfoStep extends StatefulWidget {
  final List<Contract> approvedContracts;
  final List<VehicleCatalog> vehicleCatalogs;
  final Contract? selectedContract;
  final VehicleCatalog? selectedCatalog;
  final String licensePlate;
  final Function({
    required Contract contract,
    required VehicleCatalog catalog,
    required String licensePlate,
  })
  onNext;

  const VehicleInfoStep({
    super.key,
    required this.approvedContracts,
    required this.vehicleCatalogs,
    this.selectedContract,
    this.selectedCatalog,
    required this.licensePlate,
    required this.onNext,
  });

  @override
  State<VehicleInfoStep> createState() => _VehicleInfoStepState();
}

class _VehicleInfoStepState extends State<VehicleInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _licensePlateController;
  Contract? _selectedContract;
  VehicleCatalog? _selectedCatalog;
  String? _selectedVehicleType;

  @override
  void initState() {
    super.initState();
    _licensePlateController = TextEditingController(text: widget.licensePlate);
    _selectedContract = widget.selectedContract;
    if (_selectedContract == null && widget.approvedContracts.isNotEmpty) {
      _selectedContract = widget.approvedContracts.first;
    }
    _selectedCatalog = widget.selectedCatalog;
    if (_selectedCatalog != null) {
      // Assuming 'type' or 'vehicleType' in catalog corresponds to 'car'/'motorbike'
      // You might need to adjust this matching logic based on actual API data
      _selectedVehicleType = _selectedCatalog!.type?.toLowerCase();
    }
  }

  @override
  void didUpdateWidget(covariant VehicleInfoStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.licensePlate != oldWidget.licensePlate) {
      _licensePlateController.text = widget.licensePlate;
    }
    if (widget.selectedContract != oldWidget.selectedContract) {
      setState(() => _selectedContract = widget.selectedContract);
    }
    if (widget.selectedCatalog != oldWidget.selectedCatalog) {
      setState(() {
        _selectedCatalog = widget.selectedCatalog;
        if (_selectedCatalog != null) {
          _selectedVehicleType = _selectedCatalog!.type?.toLowerCase();
        }
      });
    }
  }

  @override
  void dispose() {
    _licensePlateController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState!.validate() &&
        _selectedContract != null &&
        _selectedCatalog != null) {
      widget.onNext(
        contract: _selectedContract!,
        catalog: _selectedCatalog!,
        licensePlate: _licensePlateController.text,
      );
    } else {
      if (_selectedContract == null || _selectedCatalog == null) {
        CustomSnackbar.show(
          context,
          message: AppLocalizations.of(
            context,
          )!.fieldRequired('Contract/Catalog'),
          type: SnackbarType.error,
        );
      }
    }
  }

  List<VehicleCatalog> get _filteredCatalogs {
    if (_selectedVehicleType == null) return widget.vehicleCatalogs;
    return widget.vehicleCatalogs
        .where((c) => c.type?.toLowerCase() == _selectedVehicleType)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16.h),
          Text(
            locale.contract,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          SizedBox(height: 6.h),
          CustomTextField(
            placeholder:
                _selectedContract != null
                    ? '${locale.contract} #${_selectedContract!.id}'
                    : locale.contract,
            controller: TextEditingController(
              text:
                  _selectedContract != null
                      ? '${locale.contract} #${_selectedContract!.id}'
                      : '',
            ),
            readOnly: true,
          ),
          SizedBox(height: 16.h),

          VehicleTypeSelector(
            selectedType: _selectedVehicleType,
            label: locale.vehicleType,
            onChanged: (val) {
              setState(() {
                _selectedVehicleType = val;
                _selectedCatalog = null; // Reset catalog when type changes
              });
            },
          ),

          SizedBox(height: 16.h),
          Text(
            locale
                .vehicleModel, // Using "Vehicle Model" label or similar suitable label
            style: Theme.of(context).textTheme.displayLarge,
          ),
          SizedBox(height: 6.h),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.secondaryGrey, width: 1.w),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<VehicleCatalog>(
                value: _selectedCatalog,
                isExpanded: true,
                hint: Text(
                  locale.vehicleModel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSubtitle,
                  ),
                ),
                iconStyleData: IconStyleData(
                  icon: Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: Icon(Icons.arrow_drop_down_sharp),
                  ),
                  iconSize: 24.w,
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 28,
                        spreadRadius: 2,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  elevation: 5,
                  maxHeight: 200.h,
                  padding: EdgeInsets.zero,
                ),
                menuItemStyleData: MenuItemStyleData(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  overlayColor: MaterialStateProperty.all(
                    AppColors.secondaryGrey.withOpacity(0.1),
                  ),
                ),
                items:
                    _filteredCatalogs.map((catalog) {
                      return DropdownMenuItem(
                        value: catalog,
                        child: Text(
                          '${catalog.brand} ${catalog.model} (${catalog.color})',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                onChanged: (val) {
                  setState(() => _selectedCatalog = val);
                },
              ),
            ),
          ),

          SizedBox(height: 16.h),
          CustomTextField(
            label: locale.licensePlate,
            placeholder: locale.licensePlate,
            controller: _licensePlateController,
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? locale.fieldRequired(locale.licensePlate)
                        : null,
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                locale.continueText,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.primaryWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
