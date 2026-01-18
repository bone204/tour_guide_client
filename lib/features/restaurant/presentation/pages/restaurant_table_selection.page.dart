import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_search_response.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_table_search_response.dart';
import 'package:tour_guide_app/features/restaurant/presentation/widgets/table_card.widget.dart';
import 'package:tour_guide_app/features/cooperations/data/models/cooperation.dart';
import 'package:tour_guide_app/features/restaurant/data/models/restaurant_table.dart';

class RestaurantTableSelectionPage extends StatefulWidget {
  final RestaurantSearchResponse restaurant;
  final DateTime? reservationTime;

  const RestaurantTableSelectionPage({
    super.key,
    required this.restaurant,
    this.reservationTime,
  });

  @override
  State<RestaurantTableSelectionPage> createState() =>
      _RestaurantTableSelectionPageState();
}

class _RestaurantTableSelectionPageState
    extends State<RestaurantTableSelectionPage> {
  final Map<int, int> _selectedQuantities = {};
  List<RestaurantTableSearchResponse> _tables = [];

  @override
  void initState() {
    super.initState();
    _tables = widget.restaurant.restaurantTables;
  }

  void _onQuantityChanged(int tableId, int quantity) {
    setState(() {
      if (quantity > 0) {
        _selectedQuantities[tableId] = quantity;
      } else {
        _selectedQuantities.remove(tableId);
      }
    });
  }

  // Re-implementing build to show list/grid and bottom bar
  @override
  Widget build(BuildContext context) {
    int totalItems = 0;
    _selectedQuantities.forEach((_, qty) => totalItems += qty);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.selectTable,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body:
          _tables.isEmpty
              ? Center(
                child: Text(
                  AppLocalizations.of(context)!.noTablesAvailable,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.all(16.w),
                      itemCount: _tables.length,
                      separatorBuilder:
                          (context, index) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final table = _tables[index];
                        return TableCard(
                          table: table,
                          selectedQuantity: _selectedQuantities[table.id] ?? 0,
                          onQuantityChanged:
                              (qty) => _onQuantityChanged(table.id, qty),
                        );
                      },
                    ),
                  ),
                  _buildBottomBar(totalItems),
                ],
              ),
    );
  }

  Widget _buildBottomBar(int totalItems) {
    if (totalItems == 0) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.itemsSelected(totalItems),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            PrimaryButton(
              title: AppLocalizations.of(context)!.continueText,
              width: 120.w,
              onPressed: () {
                if (_selectedQuantities.isNotEmpty) {
                  // Build selected tables list
                  final List<Map<String, dynamic>> selectedTables = [];

                  _selectedQuantities.forEach((tableId, qty) {
                    final tableResponse = _tables.firstWhere(
                      (t) => t.id == tableId,
                    );

                    final table = RestaurantTable(
                      id: tableResponse.id,
                      name: tableResponse.name,
                      guests: tableResponse.maxPeople ?? 0,
                      priceRange: _parsePrice(tableResponse.priceRange),
                      description: tableResponse.note,
                      dishType: tableResponse.dishType,
                    );

                    selectedTables.add({'table': table, 'quantity': qty});
                  });

                  final cooperation = Cooperation(
                    id: widget.restaurant.id,
                    name: widget.restaurant.name,
                    photo: widget.restaurant.photo,
                    address: widget.restaurant.address,
                    province: widget.restaurant.province,
                    bossName: widget.restaurant.bossName,
                    bossPhone: widget.restaurant.bossPhone,
                    bossEmail: widget.restaurant.bossEmail,
                  );

                  Navigator.of(context, rootNavigator: true).pushNamed(
                    AppRouteConstant.restaurantBookingInfo,
                    arguments: {
                      'restaurant': cooperation,
                      'checkInTime': widget.reservationTime ?? DateTime.now(),
                      'selectedTables': selectedTables,
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  int? _parsePrice(String? priceRange) {
    if (priceRange == null) return null;
    final cleanPrice = priceRange
        .toLowerCase()
        .replaceAll(',', '')
        .replaceAll('.', '');
    final regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(cleanPrice);

    if (match != null) {
      int? value = int.tryParse(match.group(0)!);
      if (value != null) {
        if (cleanPrice.contains('k')) {
          value *= 1000;
        }
        return value;
      }
    }
    return null;
  }
}
