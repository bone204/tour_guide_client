import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/fast_delivery/data/models/delivery_order.dart';
import 'package:tour_guide_app/features/fast_delivery/data/models/shipping_provider.dart';
import 'package:tour_guide_app/features/fast_delivery/presentation/widgets/delivery_info_header.widget.dart';
import 'package:tour_guide_app/features/fast_delivery/presentation/widgets/image_picker_widget.dart';
import 'package:tour_guide_app/features/fast_delivery/presentation/widgets/shipping_provider_selector.widget.dart';
import 'package:tour_guide_app/features/fast_delivery/presentation/widgets/vehicle_selector.widget.dart';
import 'package:tour_guide_app/common/widgets/snackbar/custom_snackbar.dart';

class FastDeliveryDetailPage extends StatefulWidget {
  final DeliveryOrder initialOrder;

  const FastDeliveryDetailPage({super.key, required this.initialOrder});

  @override
  State<FastDeliveryDetailPage> createState() => _FastDeliveryDetailPageState();
}

class _FastDeliveryDetailPageState extends State<FastDeliveryDetailPage> {
  late DeliveryOrder _deliveryOrder;
  final _requirementsController = TextEditingController();

  // Data
  final List<ShippingProvider> _providers = ShippingProvider.getMockProviders();
  ShippingProvider? _selectedProvider;
  VehicleType? _selectedVehicle;
  List<String> _packageImages = [];

  @override
  void initState() {
    super.initState();
    _deliveryOrder = widget.initialOrder;
  }

  @override
  void dispose() {
    _requirementsController.dispose();
    super.dispose();
  }

  double _calculateTotalCost() {
    if (_selectedVehicle == null) return 0;

    // Simple calculation: base price + distance-based price
    // For demo: assume 5km distance
    final distance = 5.0;
    final distancePrice = distance * 5000; // 5000đ per km
    final totalCost = _selectedVehicle!.basePrice + distancePrice;

    return totalCost;
  }

  void _confirmOrder() {
    if (_selectedProvider == null) {
      CustomSnackbar.show(
        context,
        message: AppLocalizations.of(context)!.pleaseSelectDeliveryCompany,
        type: SnackbarType.warning,
      );
      return;
    }

    if (_selectedVehicle == null) {
      CustomSnackbar.show(
        context,
        message: AppLocalizations.of(context)!.pleaseSelectVehicleType,
        type: SnackbarType.warning,
      );
      return;
    }

    // Update delivery order with full info
    final updatedOrder = _deliveryOrder.copyWith(
      shippingProviderId: _selectedProvider!.id,
      shippingProviderName: _selectedProvider!.name,
      vehicleTypeId: _selectedVehicle!.id,
      vehicleTypeName: _selectedVehicle!.name,
      vehicleBasePrice: _selectedVehicle!.basePrice,
      packageImages: _packageImages,
      specialRequirements: _requirementsController.text,
      totalCost: _calculateTotalCost(),
      distance: 5.0, // Mock distance
    );

    // Navigate to bill page
    Navigator.of(
      context,
    ).pushNamed(AppRouteConstant.fastDeliveryBill, arguments: updatedOrder);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final totalCost = _calculateTotalCost();

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.orderDetails,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery info header
                DeliveryInfoHeader(
                  senderAddress: _deliveryOrder.senderAddress,
                  receiverName: _deliveryOrder.receiverName,
                  receiverPhone: _deliveryOrder.receiverPhone,
                  receiverAddress: _deliveryOrder.receiverAddress,
                ),

                SizedBox(height: 24.h),

                // Shipping provider selector
                ShippingProviderSelector(
                  selectedProvider: _selectedProvider,
                  providers: _providers,
                  onSelect: (provider) {
                    setState(() {
                      _selectedProvider = provider;
                      _selectedVehicle = null; // Reset vehicle selection
                    });
                  },
                ),

                SizedBox(height: 20.h),

                // Vehicle selector (only show if provider is selected)
                if (_selectedProvider != null) ...[
                  VehicleSelector(
                    selectedVehicle: _selectedVehicle,
                    vehicles: _selectedProvider!.vehicleTypes,
                    onSelect: (vehicle) {
                      setState(() {
                        _selectedVehicle = vehicle;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),
                ],

                // Image picker
                ImagePickerWidget(
                  images: _packageImages,
                  onImagesChanged: (images) {
                    setState(() {
                      _packageImages = images;
                    });
                  },
                ),

                SizedBox(height: 20.h),

                // Special requirements
                CustomTextField(
                  label: AppLocalizations.of(context)!.deliveryRequirements,
                  placeholder:
                      AppLocalizations.of(context)!.deliveryRequirements,
                  controller: _requirementsController,
                  maxLines: 3,
                ),

                SizedBox(height: 100.h), // Space for bottom bar
              ],
            ),
          ),

          // Bottom bar with total cost and confirm button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.primaryWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Tổng tiền',
                            style: theme.bodySmall?.copyWith(
                              color: AppColors.textSubtitle,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            Formatter.currency(totalCost),
                            style: theme.headlineMedium?.copyWith(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: PrimaryButton(
                        title: AppLocalizations.of(context)!.confirm,
                        onPressed: _confirmOrder,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
