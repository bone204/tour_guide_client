import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/common_libs.dart'; // For AppLocalizations, AppColors, etc.
import 'package:tour_guide_app/features/bills/rental_vehicle/data/models/rental_bill.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/rental_payment/rental_payment_cubit.dart';

class ContactInfoForm extends StatefulWidget {
  final RentalBill bill;

  const ContactInfoForm({super.key, required this.bill});

  @override
  State<ContactInfoForm> createState() => _ContactInfoFormState();
}

class _ContactInfoFormState extends State<ContactInfoForm> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.bill.contactName);
    _phoneController = TextEditingController(text: widget.bill.contactPhone);
    _notesController = TextEditingController(text: widget.bill.notes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGrey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.contactInfo,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Divider(),
          SizedBox(height: 8.h),
          _buildTextField(
            label: AppLocalizations.of(context)!.fullName,
            controller: _nameController,
            icon: Icons.person_outline,
          ),
          SizedBox(height: 12.h),
          _buildTextField(
            label: AppLocalizations.of(context)!.phoneNumber,
            controller: _phoneController,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 12.h),
          _buildTextField(
            label: AppLocalizations.of(context)!.notes,
            controller: _notesController,
            icon: Icons.note_outlined,
            maxLines: 3,
          ),
          SizedBox(height: 16.h),
          PrimaryButton(
            title: AppLocalizations.of(context)!.update,
            backgroundColor: AppColors.primaryYellow,
            textColor: AppColors.primaryBlack,
            onPressed: () {
              context.read<RentalPaymentCubit>().updateContactInfo(
                _nameController.text,
                _phoneController.text,
                _notesController.text,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.updateSuccess),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return CustomTextField(
      label: label,
      placeholder: label,
      controller: controller,
      prefixIconData: icon,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }
}
