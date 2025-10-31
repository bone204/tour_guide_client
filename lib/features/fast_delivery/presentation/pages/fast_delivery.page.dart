import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/picker/location_picker.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/fast_delivery/data/models/delivery_order.dart';

class FastDeliveryPage extends StatefulWidget {
  const FastDeliveryPage({super.key});

  @override
  State<FastDeliveryPage> createState() => _FastDeliveryPageState();
}

class _FastDeliveryPageState extends State<FastDeliveryPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _receiverNameController = TextEditingController();
  final _receiverPhoneController = TextEditingController();
  
  // Location data
  String? _pickupLocation;
  String? _deliveryLocation;

  @override
  void dispose() {
    _receiverNameController.dispose();
    _receiverPhoneController.dispose();
    super.dispose();
  }

  void _navigateToDetailPage() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_pickupLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn điểm lấy hàng')),
        );
        return;
      }
      if (_deliveryLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng chọn điểm nhận hàng')),
        );
        return;
      }

      // Create initial delivery order
      final deliveryOrder = DeliveryOrder(
        senderAddress: _pickupLocation,
        receiverName: _receiverNameController.text,
        receiverPhone: _receiverPhoneController.text,
        receiverAddress: _deliveryLocation,
      );

      // Navigate to detail page
      Navigator.of(context).pushNamed(
        AppRouteConstant.fastDeliveryDetail,
        arguments: deliveryOrder,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Giao hàng nhanh',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // Pickup location
                LocationField(
                  label: 'Điểm lấy hàng',
                  placeholder: 'Chọn điểm lấy hàng',
                  locationText: _pickupLocation,
                  onTap: () {
                    // TODO: Implement location picker
                    setState(() {
                      _pickupLocation = '123 Đường ABC, Quận 1, TP.HCM';
                    });
                  },
                  prefixIcon: Icon(
                    Icons.my_location,
                    color: AppColors.primaryBlue,
                    size: 20.sp,
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                // Delivery location
                LocationField(
                  label: 'Điểm nhận hàng',
                  placeholder: 'Chọn điểm nhận hàng',
                  locationText: _deliveryLocation,
                  onTap: () {
                    // TODO: Implement location picker
                    setState(() {
                      _deliveryLocation = '456 Đường XYZ, Quận 3, TP.HCM';
                    });
                  },
                  prefixIcon: Icon(
                    Icons.location_on,
                    color: AppColors.primaryGreen,
                    size: 20.sp,
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                // Receiver name
                CustomTextField(
                  label: 'Tên người nhận',
                  placeholder: 'Nhập tên người nhận',
                  controller: _receiverNameController,
                  prefixIconData: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên người nhận';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 16.h),
                
                // Receiver phone
                CustomTextField(
                  label: 'Số điện thoại người nhận',
                  placeholder: 'Nhập số điện thoại',
                  controller: _receiverPhoneController,
                  keyboardType: TextInputType.phone,
                  prefixIconData: Icons.phone_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    if (value.length < 10) {
                      return 'Số điện thoại không hợp lệ';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 32.h),
                
                // Continue button
                PrimaryButton(
                  title: 'Tiếp tục',
                  onPressed: _navigateToDetailPage,
                  backgroundColor: AppColors.primaryBlue,
                  textColor: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

