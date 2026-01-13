import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';

class ContactSupportPage extends StatefulWidget {
  const ContactSupportPage({super.key});

  @override
  State<ContactSupportPage> createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends State<ContactSupportPage> {
  bool _isCalling = false;
  bool _isSendingEmail = false;

  Future<void> _makePhoneCall(String phoneNumber) async {
    setState(() => _isCalling = true);
    try {
      final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
      if (!await launchUrl(launchUri)) {
        // Handle error silently or show snackbar if needed
        debugPrint('Could not launch $launchUri');
      }
    } catch (e) {
      debugPrint('Error launching phone call: $e');
    } finally {
      if (mounted) setState(() => _isCalling = false);
    }
  }

  Future<void> _sendEmail(String email) async {
    setState(() => _isSendingEmail = true);
    try {
      final Uri launchUri = Uri(scheme: 'mailto', path: email);
      if (!await launchUrl(launchUri)) {
        debugPrint('Could not launch $launchUri');
      }
    } catch (e) {
      debugPrint('Error launching email: $e');
    } finally {
      if (mounted) setState(() => _isSendingEmail = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.contactSupportTitle,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.contactUsTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              AppLocalizations.of(context)!.contactUsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            _buildContactCard(
              context,
              icon: Icons.phone_in_talk_outlined,
              title: AppLocalizations.of(context)!.supportHotline,
              content: "0914259475",
              actionLabel: AppLocalizations.of(context)!.callNow,
              onTap: () => _makePhoneCall("0914259475"),
              isLoading: _isCalling,
            ),
            SizedBox(height: 16.h),
            _buildContactCard(
              context,
              icon: Icons.email_outlined,
              title: AppLocalizations.of(context)!.supportEmail,
              content: "truongbmt4@gmail.com",
              actionLabel: AppLocalizations.of(context)!.sendEmail,
              onTap: () => _sendEmail("truongbmt4@gmail.com"),
              isLoading: _isSendingEmail,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required String actionLabel,
    required VoidCallback onTap,
    required bool isLoading,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32.sp,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8.h),
          Text(content, style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 20.h),
          PrimaryButton(
            onPressed: onTap,
            title: actionLabel,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
