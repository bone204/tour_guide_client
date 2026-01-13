import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.policy,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacyPolicyTitle,
              content: "",
              isMainTitle: true,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacyOverview,
              content: AppLocalizations.of(context)!.privacyOverviewContent,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacyCollection,
              content: AppLocalizations.of(context)!.privacyCollectionContent,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacyUsage,
              content: AppLocalizations.of(context)!.privacyUsageContent,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacySharing,
              content: AppLocalizations.of(context)!.privacySharingContent,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacySecurity,
              content: AppLocalizations.of(context)!.privacySecurityContent,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacyRights,
              content: AppLocalizations.of(context)!.privacyRightsContent,
            ),
            _buildSection(
              context,
              title: AppLocalizations.of(context)!.privacyContact,
              content: AppLocalizations.of(context)!.privacyContactContent,
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
            _buildFormattedContent(context, content),
          ],
        ],
      ),
    );
  }

  Widget _buildFormattedContent(BuildContext context, String content) {
    return Text(
      content,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(height: 1.5, color: Colors.black87),
      textAlign: TextAlign.justify,
    );
  }
}
