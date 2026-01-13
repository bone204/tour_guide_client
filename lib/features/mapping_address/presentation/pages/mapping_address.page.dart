import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tour_guide_app/common/constants/app_route.constant.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';
import 'package:tour_guide_app/features/mapping_address/presentation/widgets/mapping_navigation_button.dart';

class MappingAddressPage extends StatelessWidget {
  const MappingAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.mappingAddressTitle,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  MappingNavigationButton(
                    title:
                        AppLocalizations.of(
                          context,
                        )!.convertOldToNewAddressTitle,
                    description:
                        AppLocalizations.of(
                          context,
                        )!.convertOldToNewAddressDesc,
                    icon: Icons.transform,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouteConstant.convertOldToNewAddress,
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                  MappingNavigationButton(
                    title:
                        AppLocalizations.of(
                          context,
                        )!.convertNewToOldAddressTitle,
                    description:
                        AppLocalizations.of(
                          context,
                        )!.convertNewToOldAddressDesc,
                    icon: Icons.history,
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouteConstant.convertNewToOldAddress,
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                  MappingNavigationButton(
                    title:
                        AppLocalizations.of(
                          context,
                        )!.convertOldToNewDetailsTitle,
                    description:
                        AppLocalizations.of(
                          context,
                        )!.convertOldToNewDetailsDesc,
                    icon: Icons.account_tree,
                    color: Colors.green,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouteConstant.convertOldToNewDetails,
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                  MappingNavigationButton(
                    title:
                        AppLocalizations.of(
                          context,
                        )!.convertNewToOldDetailsTitle,
                    description:
                        AppLocalizations.of(
                          context,
                        )!.convertNewToOldDetailsDesc,
                    icon: Icons.merge_type,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRouteConstant.convertNewToOldDetails,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
