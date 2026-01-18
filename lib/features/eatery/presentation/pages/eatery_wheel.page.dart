import 'dart:async';

import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/features/eatery/data/models/eatery.dart';
import 'package:tour_guide_app/common/constants/app_route.constant.dart';
import 'package:tour_guide_app/features/eatery/domain/usecases/get_nearby_eateries_use_case.dart';
import 'package:tour_guide_app/features/eatery/domain/usecases/get_random_eatery_use_case.dart';
import 'package:tour_guide_app/service_locator.dart';

class EateryWheelPage extends StatefulWidget {
  final List<Eatery>? eateries;

  const EateryWheelPage({super.key, this.eateries});

  @override
  State<EateryWheelPage> createState() => _EateryWheelPageState();
}

class _EateryWheelPageState extends State<EateryWheelPage> {
  StreamController<int> selected = StreamController<int>.broadcast();
  int? _selectedResultIndex;
  bool _isSpinning = false;
  bool _isLoading = false;
  List<Eatery> _nearbyEateries = [];
  Set<int> _selectedEateryIds = {};

  final List<Color> _colors = [
    const Color(0xFFFF6B6B),
    const Color(0xFF4ECDC4),
    const Color(0xFFFFD93D),
    const Color(0xFF6C5CE7),
    const Color(0xFFA8E6CF),
    const Color(0xFFFD79A8),
    const Color(0xFFA29BFE),
    const Color(0xFFFF9F43),
  ];

  @override
  void initState() {
    super.initState();
    _nearbyEateries = List.from(widget.eateries ?? []);
    _selectedEateryIds = _nearbyEateries.map((e) => e.id).toSet();
    _fetchNearbyEateries();
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  Future<void> _fetchNearbyEateries() async {
    setState(() => _isLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final position = await Geolocator.getCurrentPosition();
        final result = await sl<GetNearbyEateriesUseCase>().call(
          NearbyEateryParams(
            latitude: position.latitude,
            longitude: position.longitude,
            radius: 5, // 5km
          ),
        );

        result.fold((failure) => _showError(failure.message), (eateries) {
          debugPrint(
            '=== NEARBY EATERIES LOADED: ${eateries.length} items ===',
          );
          if (!mounted) return;
          setState(() {
            _nearbyEateries = eateries;
            _selectedEateryIds = eateries.map((e) => e.id).toSet();
          });
          debugPrint(
            '=== STATE UPDATED: _nearbyEateries.length = ${_nearbyEateries.length} ===',
          );
        });
      }
    } catch (e) {
      debugPrint('=== ERROR in _fetchNearbyEateries: $e ===');
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _spin() async {
    if (_isSpinning || _selectedEateryIds.isEmpty) return;

    if (_selectedEateryIds.length < 2) {
      _showError("Vui lòng chọn ít nhất 2 quán ăn để quay!");
      return;
    }

    setState(() => _isSpinning = true);

    final result = await sl<GetRandomEateryUseCase>().call(
      RandomEateryParams(eateryIds: _selectedEateryIds.toList()),
    );

    result.fold(
      (failure) {
        if (mounted) setState(() => _isSpinning = false);
        _showError(failure.message);
      },
      (eatery) {
        // Find index in the wheel items
        final wheelItems = _getWheelItems();
        int index = wheelItems.indexWhere((e) => e.id == eatery.id);

        if (index != -1) {
          _selectedResultIndex = index;
          // IMPORTANT: Emit the index to spin the wheel
          selected.add(index);
        } else if (wheelItems.isNotEmpty) {
          // If for some reason not in wheel but wheel has items,
          // spin to first item as fallback but show correct dialog
          _selectedResultIndex = 0;
          selected.add(0);
          // Overwrite the result to show in dialog
          _selectedResultIndex = -1; // Special flag
          _showResultDialog(eatery);
        } else {
          // Fallback if no wheel items
          if (mounted) setState(() => _isSpinning = false);
          _showResultDialog(eatery);
        }
      },
    );
  }

  List<Eatery> _getWheelItems() {
    final selectedEateries = _nearbyEateries
        .where((e) => _selectedEateryIds.contains(e.id))
        .toList();
    if (selectedEateries.isEmpty) return [];

    // Ensure at least 2 for wheel
    if (selectedEateries.length < 2) {
      return [...selectedEateries, ...selectedEateries];
    }

    // Increase limit to 50 items for better coverage
    return selectedEateries.take(50).toList();
  }

  void _showResultDialog([Eatery? directResult]) {
    final result = directResult ?? _getWheelItems()[_selectedResultIndex!];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          AppLocalizations.of(context)!.eateryWheelResultTitle,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (result.imageUrl != null && result.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    result.imageUrl!,
                    height: 120.h,
                    width: 280,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120.h,
                      width: 280,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryGrey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.restaurant,
                        size: 48,
                        color: AppColors.secondaryGrey,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 16.h),
              Text(
                result.name ?? '',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              if (result.address != null) ...[
                SizedBox(height: 8.h),
                Text(
                  result.address!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSubtitle,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                AppRouteConstant.eateryDetail,
                arguments: result.id,
              );
            },
            child: Text(
              AppLocalizations.of(context)!.viewDetail,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wheelItems = _getWheelItems();

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.eateryWheelTitle,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryBlue.withOpacity(0.05),
                          Colors.white,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (wheelItems.isNotEmpty)
                          _buildWheel(wheelItems)
                        else
                          _buildEmptyWheelPlaceholder(),
                        SizedBox(height: 40.h),
                        SizedBox(
                          width: 220.w,
                          child: PrimaryButton(
                            title: AppLocalizations.of(context)!.spinWheel,
                            onPressed: _spin,
                            isLoading: _isSpinning,
                            width: 220.w,
                            backgroundColor: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildEaterySelectionList(),
              ],
            ),
    );
  }

  Widget _buildWheel(List<Eatery> wheelItems) {
    return SizedBox(
      height: 320.w,
      width: 320.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          FortuneWheel(
            key: ValueKey(
              wheelItems.length.toString() +
                  wheelItems.map((e) => e.id).join(','),
            ),
            selected: selected.stream,
            animateFirst: false,
            onAnimationEnd: () {
              setState(() => _isSpinning = false);
              _showResultDialog();
            },
            physics: CircularPanPhysics(
              duration: const Duration(seconds: 4),
              curve: Curves.decelerate,
            ),
            items: [
              for (int i = 0; i < wheelItems.length; i++)
                FortuneItem(
                  style: FortuneItemStyle(
                    color: _colors[i % _colors.length],
                    borderColor: Colors.white,
                    borderWidth: 2,
                    textStyle:
                        (Theme.of(context).textTheme.bodyMedium ??
                                const TextStyle())
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 11.sp,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Text(
                      wheelItems[i].name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
            indicators: const <FortuneIndicator>[
              FortuneIndicator(
                alignment: Alignment.topCenter,
                child: TriangleIndicator(color: Colors.redAccent),
              ),
            ],
          ),
          _buildWheelCenter(),
        ],
      ),
    );
  }

  Widget _buildWheelCenter() {
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 3),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant_rounded,
          color: AppColors.primaryBlue,
          size: 24.sp,
        ),
      ),
    );
  }

  Widget _buildEmptyWheelPlaceholder() {
    return Container(
      height: 300.w,
      width: 300.w,
      decoration: BoxDecoration(
        color: AppColors.secondaryGrey.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.secondaryGrey.withOpacity(0.2)),
      ),
      child: Center(
        child: Text(
          "Chọn quán ăn bên dưới\nđể quay!",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSubtitle, fontSize: 14.sp),
        ),
      ),
    );
  }

  Widget _buildEaterySelectionList() {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Quán ăn gần đây (${_nearbyEateries.length})",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (_selectedEateryIds.length ==
                            _nearbyEateries.length) {
                          _selectedEateryIds.clear();
                        } else {
                          _selectedEateryIds = _nearbyEateries
                              .map((e) => e.id)
                              .toSet();
                        }
                      });
                    },
                    child: Text(
                      _selectedEateryIds.length == _nearbyEateries.length
                          ? "Bỏ hết"
                          : "Chọn hết",
                      style: TextStyle(color: AppColors.primaryBlue),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _nearbyEateries.isEmpty
                  ? Center(child: Text("Không tìm thấy quán ăn nào gần đây"))
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      itemCount: _nearbyEateries.length,
                      separatorBuilder: (_, __) => SizedBox(height: 8.h),
                      itemBuilder: (context, index) {
                        final eatery = _nearbyEateries[index];
                        final isSelected = _selectedEateryIds.contains(
                          eatery.id,
                        );
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedEateryIds.remove(eatery.id);
                              } else {
                                _selectedEateryIds.add(eatery.id);
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryBlue.withOpacity(0.05)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryBlue.withOpacity(0.3)
                                    : AppColors.secondaryGrey.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: eatery.imageUrl != null
                                      ? Image.network(
                                          eatery.imageUrl!,
                                          width: 50.w,
                                          height: 50.w,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 50.w,
                                          height: 50.w,
                                          color: AppColors.secondaryGrey
                                              .withOpacity(0.1),
                                          child: Icon(
                                            Icons.restaurant,
                                            size: 20.sp,
                                          ),
                                        ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        eatery.name ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14.sp,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (eatery.address != null)
                                        Text(
                                          eatery.address!,
                                          style: TextStyle(
                                            color: AppColors.textSubtitle,
                                            fontSize: 12.sp,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (val) {
                                    setState(() {
                                      if (val == true) {
                                        _selectedEateryIds.add(eatery.id);
                                      } else {
                                        _selectedEateryIds.remove(eatery.id);
                                      }
                                    });
                                  },
                                  activeColor: AppColors.primaryBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
