import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/widgets/bank_dropdown.widget.dart';

class BankingInfoStep extends StatefulWidget {
  final String? bankName;
  final String? bankAccountNumber;
  final String? bankAccountName;
  final bool termsAccepted;
  final Function({
    String? bankName,
    String? bankAccountNumber,
    String? bankAccountName,
    required bool termsAccepted,
  }) onSubmit;
  final VoidCallback onBack;

  const BankingInfoStep({
    super.key,
    this.bankName,
    this.bankAccountNumber,
    this.bankAccountName,
    required this.termsAccepted,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  State<BankingInfoStep> createState() => _BankingInfoStepState();
}

class _BankingInfoStepState extends State<BankingInfoStep> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBank;
  late TextEditingController _accountNumberController;
  late TextEditingController _accountNameController;
  bool _confirmPolicy1 = false;
  bool _confirmPolicy2 = false;
  bool _confirmPolicy3 = false;

  @override
  void initState() {
    super.initState();
    _selectedBank = widget.bankName;
    _accountNumberController = TextEditingController(text: widget.bankAccountNumber);
    _accountNameController = TextEditingController(text: widget.bankAccountName);
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _accountNameController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateBankSelection() {
    if (_selectedBank == null || _selectedBank!.isEmpty) {
      return 'Please select a bank';
    }
    return null;
  }

  bool _validateAllConfirmations() {
    return _confirmPolicy1 && _confirmPolicy2 && _confirmPolicy3;
  }

  void _handleSubmit() {
    final bankError = _validateBankSelection();
    if (!_formKey.currentState!.validate() || bankError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(bankError ?? 'Please fill all required fields'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      return;
    }

    if (!_validateAllConfirmations()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please confirm all policies'),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      return;
    }

    widget.onSubmit(
      bankName: _selectedBank,
      bankAccountNumber: _accountNumberController.text,
      bankAccountName: _accountNameController.text,
      termsAccepted: true,
    );
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
            BankDropdown(
              label: 'Bank Name',
              selectedBank: _selectedBank,
              onChanged: (value) {
                setState(() {
                  _selectedBank = value;
                });
              },
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: 'Bank Account Number',
              placeholder: 'Enter account number',
              controller: _accountNumberController,
              keyboardType: TextInputType.number,
              validator: (value) => _validateRequired(value, 'Account number'),
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              label: 'Bank Account Name',
              placeholder: 'Enter account holder name',
              controller: _accountNameController,
              validator: (value) => _validateRequired(value, 'Account name'),
            ),
            SizedBox(height: 24.h),
            _buildCheckbox(
              value: _confirmPolicy1,
              onChanged: (value) {
                setState(() {
                  _confirmPolicy1 = value ?? false;
                });
              },
              label: 'I confirm that all information provided is accurate and complete',
            ),
            SizedBox(height: 12.h),
            _buildCheckbox(
              value: _confirmPolicy2,
              onChanged: (value) {
                setState(() {
                  _confirmPolicy2 = value ?? false;
                });
              },
              label: 'I agree to the terms and conditions of vehicle rental services',
            ),
            SizedBox(height: 12.h),
            _buildCheckbox(
              value: _confirmPolicy3,
              onChanged: (value) {
                setState(() {
                  _confirmPolicy3 = value ?? false;
                });
              },
              label: 'I authorize the platform to use my banking information for payment processing',
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
                      'Back',
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
                      'Submit',
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

  Widget _buildCheckbox({
    required bool value,
    required Function(bool?) onChanged,
    required String label,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
