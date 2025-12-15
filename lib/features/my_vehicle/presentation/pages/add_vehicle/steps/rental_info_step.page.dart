import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';

class RentalInfoStep extends StatefulWidget {
  final String? pricePerHour;
  final String? pricePerDay;
  final String? requirements;
  final Function({
    String? pricePerHour,
    String? pricePerDay,
    String? requirements,
  })
  onSubmit;
  final VoidCallback onBack;

  const RentalInfoStep({
    super.key,
    this.pricePerHour,
    this.pricePerDay,
    this.requirements,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  State<RentalInfoStep> createState() => _RentalInfoStepState();
}

class _RentalInfoStepState extends State<RentalInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _pricePerHourController;
  late TextEditingController _pricePerDayController;
  late TextEditingController _requirementsController;
  final _currencyFormatter = _CurrencyInputFormatter();
  final NumberFormat _numberFormat = NumberFormat('#,###', 'vi_VN');

  @override
  void initState() {
    super.initState();
    _pricePerHourController = TextEditingController(
      text: _formatCurrency(widget.pricePerHour),
    );
    _pricePerDayController = TextEditingController(
      text: _formatCurrency(widget.pricePerDay),
    );
    _requirementsController = TextEditingController(text: widget.requirements);
  }

  @override
  void dispose() {
    _pricePerHourController.dispose();
    _pricePerDayController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  String _sanitizeNumber(String? value) {
    if (value == null) return '';
    return value.replaceAll(RegExp(r'[^0-9]'), '');
  }

  String? _formatCurrency(String? value) {
    final digits = _sanitizeNumber(value);
    if (digits.isEmpty) return '';
    final number = int.tryParse(digits);
    if (number == null) return '';
    return _numberFormat.format(number);
  }

  String? _validatePrice(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.fieldRequired(fieldName);
    }
    final price = double.tryParse(_sanitizeNumber(value));
    if (price == null || price <= 0) {
      return AppLocalizations.of(context)!.pleaseEnterValidPrice;
    }
    return null;
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        pricePerHour: _sanitizeNumber(_pricePerHourController.text),
        pricePerDay: _sanitizeNumber(_pricePerDayController.text),
        requirements: _requirementsController.text,
      );
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
            CustomTextField(
              label: AppLocalizations.of(context)!.pricePerHourVnd,
              placeholder: AppLocalizations.of(context)!.enterPricePerHour,
              controller: _pricePerHourController,
              keyboardType: TextInputType.number,
              validator:
                  (value) => _validatePrice(
                    value,
                    AppLocalizations.of(context)!.pricePerHour,
                  ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                _currencyFormatter,
              ],
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.pricePerDayVnd,
              placeholder: AppLocalizations.of(context)!.enterPricePerDay,
              controller: _pricePerDayController,
              keyboardType: TextInputType.number,
              validator:
                  (value) => _validatePrice(
                    value,
                    AppLocalizations.of(context)!.pricePerDay,
                  ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                _currencyFormatter,
              ],
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: AppLocalizations.of(context)!.requirements,
              placeholder: AppLocalizations.of(context)!.requirements,
              controller: _requirementsController,
              maxLines: 5,
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
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.submit,
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

class _CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###', 'vi_VN');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return const TextEditingValue(text: '');
    }

    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }

    final number = int.parse(digitsOnly);
    final newText = _formatter.format(number);
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
