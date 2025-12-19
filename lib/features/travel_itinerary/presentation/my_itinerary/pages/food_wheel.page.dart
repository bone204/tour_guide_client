import 'dart:async';
import 'dart:math';

import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';

class FoodWheelPage extends StatefulWidget {
  const FoodWheelPage({super.key});

  @override
  State<FoodWheelPage> createState() => _FoodWheelPageState();
}

class _FoodWheelPageState extends State<FoodWheelPage> {
  StreamController<int> selected = StreamController<int>();
  int? _selectedResultIndex;
  bool _isSpinning = false;

  final List<String> _foods = [
    'Phở',
    'Bún Chả',
    'Cơm Tấm',
    'Bánh Mì',
    'Hủ Tiếu',
    'Bún Bò',
    'Mì Quảng',
    'Bánh Xèo',
  ];

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

    final randomIndex = Random().nextInt(_foods.length);
    _selectedResultIndex = randomIndex;
    selected.add(randomIndex);
  }

  void _showResultDialog() {
    if (_selectedResultIndex == null) return;

    final result = _foods[_selectedResultIndex!];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.foodWheelResultTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            content: Text(
              result,
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
                  // State is already reset in onAnimationEnd, so just pop is enough
                  // But just in case user closed by back button (if barrierDismissible were true)
                },
                child: Text(AppLocalizations.of(context)!.awesome),
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
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.foodWheelTitle,
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
              AppLocalizations.of(context)!.foodWheelTitle,
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
                      for (int i = 0; i < _foods.length; i++)
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
                            child: Text(_foods[i]),
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
              width: 200.w, // Reasonable width
              backgroundColor: Colors.teal,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
