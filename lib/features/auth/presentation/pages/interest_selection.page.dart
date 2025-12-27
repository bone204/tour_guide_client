import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common/widgets/dropdown/lang_dropdown.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/update_hobbies/update_hobbies_cubit.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/update_hobbies/update_hobbies_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class InterestSelectionPage extends StatefulWidget {
  const InterestSelectionPage({Key? key}) : super(key: key);

  @override
  State<InterestSelectionPage> createState() => _InterestSelectionPageState();
}

class _InterestSelectionPageState extends State<InterestSelectionPage>
    with SingleTickerProviderStateMixin {
  final List<String> _selectedHobbies = [];

  Map<String, String> _hobbyKeys = {};
  AnimationController? _headerAnimationController;

  @override
  void initState() {
    super.initState();
    _initAnimationController();
  }

  void _initAnimationController() {
    _headerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _headerAnimationController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    _hobbyKeys = {
      'adventure': l10n.adventure,
      'relaxation': l10n.relaxation,
      'cultureHistory': l10n.cultureHistory,
      'entertainment': l10n.entertainment,
      'nature': l10n.nature,
      'beachIslands': l10n.beachIslands,
      'mountainForest': l10n.mountainForest,
      'photography': l10n.photography,
      'foodsDrinks': l10n.foodsDrinks,
    };
  }

  void _toggleHobby(String key) {
    setState(() {
      if (_selectedHobbies.contains(key)) {
        _selectedHobbies.remove(key);
      } else {
        _selectedHobbies.add(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UpdateHobbiesCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<UpdateHobbiesCubit, UpdateHobbiesState>(
          listener: (context, state) {
            if (state is UpdateHobbiesSuccess) {
              Navigator.pushReplacementNamed(
                context,
                AppRouteConstant.mainScreen,
              );
            }
            if (state is UpdateHobbiesFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    _buildHeader(context),
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio: 2.8,
                        ),
                        itemCount: _hobbyKeys.length,
                        itemBuilder: (context, index) {
                          final entry = _hobbyKeys.entries.elementAt(index);
                          final isSelected = _selectedHobbies.contains(
                            entry.key,
                          );
                          return _buildInterestChip(
                            entry.key,
                            entry.value,
                            isSelected,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 30.h,
                      ),
                      child: PrimaryButton(
                        title: AppLocalizations.of(context)!.getStarted,
                        onPressed:
                            _selectedHobbies.isNotEmpty &&
                                    state is! UpdateHobbiesLoading
                                ? () {
                                  context
                                      .read<UpdateHobbiesCubit>()
                                      .updateHobbies(_selectedHobbies);
                                }
                                : null,
                        backgroundColor: AppColors.primaryBlue,
                        textColor: AppColors.primaryWhite,
                        isLoading: state is UpdateHobbiesLoading,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 50.h,
                  right: 20.w,
                  child: const LanguageDropdown(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (_headerAnimationController == null) _initAnimationController();
    return AnimatedBuilder(
      animation: _headerAnimationController!,
      builder: (context, child) {
        return ClipPath(
          clipper: HeaderClipper(_headerAnimationController!.value),
          child: Container(
            width: double.infinity,
            height: 320.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            color: const Color(0xFF64B5F6),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 70.h),
                  Text(
                    AppLocalizations.of(context)!.whatFascinatesYou,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    AppLocalizations.of(context)!.interestSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInterestChip(String key, String label, bool isSelected) {
    return GestureDetector(
      onTap: () => _toggleHobby(key),
      child: Container(
        // GridView handles spacing via crossAxisSpacing/mainAxisSpacing.
        // Internal padding handling:
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF007AFF) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGrey.withOpacity(0.25),
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
          border:
              isSelected
                  ? null
                  : Border.all(color: Colors.transparent), // Maintain size
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp, // Ensuring it fits
          ),
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  final double value;

  HeaderClipper(this.value);

  @override
  Path getClip(Size size) {
    final path = Path();
    final double yBase = size.height - 50;
    path.lineTo(0, yBase);

    // Sine wave
    for (double x = 0; x <= size.width; x++) {
      double y =
          yBase +
          20 * math.sin((2 * math.pi * x / size.width) + (2 * math.pi * value));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant HeaderClipper oldClipper) {
    return true;
  }
}
