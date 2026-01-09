import 'package:flutter/material.dart';

import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/image_picker_field.widget.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/business_type_selector.widget.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tour_guide_app/common/pages/location_map.page.dart';

class BusinessInfoStep extends StatefulWidget {
  final String businessType;
  final String? businessName;
  final String? businessAddress;
  final String? taxCode;
  final String? businessRegisterPhoto;
  final String? notes;
  final Function({
    required String businessType,
    String? businessName,
    String? businessAddress,
    String? taxCode,
    String? businessRegisterPhoto,
    String? notes,
    required double? lat,
    required double? lng,
  })
  onNext;
  final VoidCallback onBack;

  const BusinessInfoStep({
    super.key,
    required this.businessType,
    this.businessName,
    this.businessAddress,
    this.taxCode,
    this.businessRegisterPhoto,
    this.notes,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<BusinessInfoStep> createState() => _BusinessInfoStepState();
}

class _BusinessInfoStepState extends State<BusinessInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late String _businessType;
  late TextEditingController _businessNameController;
  late TextEditingController _businessAddressController;
  late TextEditingController _taxCodeController;
  late TextEditingController _notesController;
  String? _businessRegisterPhotoPath;

  // Map state
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _businessType = widget.businessType;
    _businessNameController = TextEditingController(text: widget.businessName);
    _businessAddressController = TextEditingController(
      text: widget.businessAddress,
    );
    _taxCodeController = TextEditingController(text: widget.taxCode);
    _notesController = TextEditingController(text: widget.notes);
    _businessRegisterPhotoPath = widget.businessRegisterPhoto;
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _taxCodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired(fieldName);
    }
    return null;
  }

  void _handleNext() {
    final isFormValid = _formKey.currentState!.validate();

    if (isFormValid) {
      widget.onNext(
        businessType: _businessType,
        businessName: _businessNameController.text,
        businessAddress: _businessAddressController.text,
        taxCode: _taxCodeController.text,
        businessRegisterPhoto: _businessRegisterPhotoPath,
        notes: _notesController.text,
        lat: _selectedLocation?.latitude,
        lng: _selectedLocation?.longitude,
      );
    }
  }

  Future<void> _pickLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => LocationMapPage(initialLocation: _selectedLocation),
      ),
    );

    if (result != null && result is Map) {
      setState(() {
        _selectedLocation = LatLng(result['lat'], result['lng']);
        _businessAddressController.text = result['address'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BusinessTypeSelector(
              label: AppLocalizations.of(context)!.businessType,
              selectedType: _businessType,
              onChanged: (type) {
                setState(() {
                  _businessType = type;
                });
              },
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.businessName,
              placeholder: AppLocalizations.of(context)!.enterBusinessName,
              controller: _businessNameController,
              validator:
                  (value) => _validateRequired(
                    value,
                    AppLocalizations.of(context)!.businessName,
                  ),
            ),
            SizedBox(height: 16.h),
            SizedBox(height: 16.h),
            // Map Selector for Address
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.businessAddress,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlack,
                  ),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: _pickLocation,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12.r),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Map Preview
                        SizedBox(
                          height: 150.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12.r),
                            ),
                            child:
                                _selectedLocation == null
                                    ? Container(
                                      color: Colors.grey.shade100,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.map_outlined,
                                              size: 32.sp,
                                              color: AppColors.primaryBlue,
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.tapToSelectLocation,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.copyWith(
                                                color: AppColors.primaryBlue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    : IgnorePointer(
                                      child: FlutterMap(
                                        options: MapOptions(
                                          initialCenter: _selectedLocation!,
                                          initialZoom: 15.0,
                                        ),
                                        children: [
                                          TileLayer(
                                            urlTemplate:
                                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                          ),
                                          MarkerLayer(
                                            markers: [
                                              Marker(
                                                point: _selectedLocation!,
                                                width: 30,
                                                height: 30,
                                                child: const Icon(
                                                  Icons.location_on,
                                                  color: Colors.red,
                                                  size: 30,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                          ),
                        ),
                        // Address Text
                        Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _businessAddressController.text.isEmpty
                                      ? AppLocalizations.of(
                                        context,
                                      )!.enterBusinessAddress
                                      : _businessAddressController.text,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color:
                                        _businessAddressController.text.isEmpty
                                            ? Colors.grey.shade400
                                            : AppColors.primaryBlack,
                                  ),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14.sp,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_businessAddressController.text.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h, left: 12.w),
                    child: Text(
                      _validateRequired(
                            '',
                            AppLocalizations.of(context)!.businessAddress,
                          ) ??
                          '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.taxCode,
              placeholder: AppLocalizations.of(context)!.enterTaxCode,
              controller: _taxCodeController,
              validator:
                  (value) => _validateRequired(
                    value,
                    AppLocalizations.of(context)!.taxCode,
                  ),
            ),
            if (_businessType == 'company') ...[
              SizedBox(height: 20.h),
              ImagePickerField(
                title: AppLocalizations.of(context)!.businessRegisterPhoto,
                imagePath: _businessRegisterPhotoPath,
                onImageSelected: (path) {
                  setState(() {
                    _businessRegisterPhotoPath = path;
                  });
                },
              ),
            ],
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.notes,
              placeholder: AppLocalizations.of(context)!.note,
              controller: _notesController,
              maxLines: 4,
            ),
            SizedBox(height: 32.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onBack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryGrey,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.back,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  flex: 2,
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
                      AppLocalizations.of(context)!.next,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.primaryWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
