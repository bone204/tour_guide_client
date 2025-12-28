import 'dart:async';
import 'dart:math';

import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/features/eatery/data/models/eatery.dart';
import 'package:tour_guide_app/common/constants/app_route.constant.dart';

class EateryWheelPage extends StatefulWidget {
  final List<Eatery> eateries;

  const EateryWheelPage({super.key, required this.eateries});

  @override
  State<EateryWheelPage> createState() => _EateryWheelPageState();
}

class _EateryWheelPageState extends State<EateryWheelPage> {
  StreamController<int> selected = StreamController<int>();
  int? _selectedResultIndex;
  bool _isSpinning = false;

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
  void dispose() {
    selected.close();
    super.dispose();
  }

  void _spin() {
    if (_isSpinning) return;

    setState(() {
      _isSpinning = true;
      _selectedResultIndex = null;
    });

    final randomIndex = Random().nextInt(widget.eateries.length);
    _selectedResultIndex = randomIndex;
    selected.add(randomIndex);
  }

  void _showResultDialog() {
    if (_selectedResultIndex == null) return;

    final result = widget.eateries[_selectedResultIndex!];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.eateryWheelResultTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            content: Text(
              result.name ?? '',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
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
                child: Text(AppLocalizations.of(context)!.viewDetail),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _spin();
                },
                child: Text(AppLocalizations.of(context)!.spinAgain),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure we have at least 2 items for the wheel to work properly
    final eateries =
        widget.eateries.length < 2
            ? [...widget.eateries, ...widget.eateries]
            : widget.eateries;

    // Use a subset if too many
    final wheelItems = eateries.take(12).toList();
    if (wheelItems.length < 2) {
      // Should not happen if passed correctly, but handled safely
      return Scaffold(
        appBar: CustomAppBar(
          title: AppLocalizations.of(context)!.eateryWheelTitle,
          showBackButton: true,
          onBackPressed: () => Navigator.pop(context),
        ),
        body: Center(child: Text("Not enough eateries to spin!")),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.eateryWheelTitle,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Color(0xFFFFFFFF)],
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.eateryWheelTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.teal.shade800,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 40.h),
            SizedBox(
              height: 350.w,
              width: 350.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FortuneWheel(
                    selected: selected.stream,
                    animateFirst: false,
                    onAnimationEnd: () {
                      setState(() {
                        _isSpinning = false;
                      });
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
                                Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize:
                                      12.sp, // Smaller font for longer names
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ) ??
                                const TextStyle(),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.w),
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
                  // Center Knob Decoration
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    child: Center(
                      child: Icon(Icons.star, color: Colors.teal, size: 24.r),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 60.h),
            PrimaryButton(
              title: AppLocalizations.of(context)!.spinWheel,
              onPressed: _spin,
              isLoading: _isSpinning,
              width: 200.w,
              backgroundColor: Colors.teal,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
