import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.termsAndPolicies,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsAndPoliciesTitle,
              content: "",
              isMainTitle: true,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsScopePurpose,
              content: AppLocalizations.of(context)!.termsScopeContent,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsUserRights,
              content: AppLocalizations.of(context)!.termsUserRightsContent,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsServiceContract,
              content:
                  AppLocalizations.of(context)!.termsServiceContractContent,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsPaymentDeposit,
              content: AppLocalizations.of(context)!.termsPaymentDepositContent,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsCancellationRefund,
              content:
                  AppLocalizations.of(context)!.termsCancellationRefundContent,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsSecurityData,
              content: AppLocalizations.of(context)!.termsSecurityDataContent,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsLiabilityLimitation,
              content:
                  AppLocalizations.of(context)!.termsLiabilityLimitationContent,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsCancellationRights,
              content:
                  AppLocalizations.of(context)!.termsCancellationRightsContent,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.termsLegalDispute,
              content: AppLocalizations.of(context)!.termsLegalDisputeContent,
            ),
            Divider(height: 32.h),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.specificTermsCarRental,
              content: "",
              isMainTitle: true,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.contractAddendum,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    AppLocalizations.of(context)!.contractAddendumRef,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.renterResponsibility,
              content:
                  AppLocalizations.of(context)!.renterResponsibilityContent,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.ownerResponsibility,
              content: AppLocalizations.of(context)!.ownerResponsibilityContent,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.depositTerms,
              content: AppLocalizations.of(context)!.depositTermsContent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
    bool isMainTitle = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                isMainTitle
                    ? Theme.of(context).textTheme.titleLarge
                    : Theme.of(context).textTheme.titleMedium,
            textAlign: isMainTitle ? TextAlign.center : TextAlign.start,
          ),
          if (content.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ],
      ),
    );
  }
}
