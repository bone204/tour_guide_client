import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';

class ContractCard extends StatelessWidget {
  final Contract contract;
  final VoidCallback? onTap;

  const ContractCard({super.key, required this.contract, this.onTap});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final locale = AppLocalizations.of(context)!;

    Color statusColor;
    String statusText;

    switch (contract.status.toLowerCase()) {
      case 'approved':
        statusColor = Colors.green;
        statusText = locale.approved;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = locale.rejected;
        break;
      case 'pending':
      default:
        statusColor = Colors.orange;
        statusText = locale.pending;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGrey.withOpacity(0.25),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, statusColor, statusText),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Divider(height: 1, color: Colors.grey[200]),
                ),
                _buildSectionTitle(context, locale.contractOwnerInfo),
                SizedBox(height: 12.h),
                _buildOwnerInfo(context),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Divider(height: 1, color: Colors.grey[200]),
                ),
                _buildSectionTitle(context, locale.contractInfo),
                SizedBox(height: 12.h),
                _buildContractInfo(context),
                if (contract.status.toLowerCase() == 'rejected' &&
                    contract.rejectedReason != null) ...[
                  SizedBox(height: 16.h),
                  _buildRejectionReason(context, locale),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    Color statusColor,
    String statusText,
  ) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.contractTitle(contract.id),
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.primaryBlue,
              ),
            ),
            if (contract.createdAt.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Text(
                _formatDate(contract.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: statusColor.withOpacity(0.2)),
          ),
          child: Text(
            statusText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(
        context,
      ).textTheme.displayLarge?.copyWith(color: AppColors.primaryGreen),
    );
  }

  Widget _buildOwnerInfo(BuildContext context) {
    return Column(
      children: [
        _buildInfoRow(context, AppIcons.user, contract.fullName),
        SizedBox(height: 6.h),
        _buildInfoRow(context, AppIcons.contact, contract.phoneNumber),
      ],
    );
  }

  Widget _buildContractInfo(BuildContext context) {
    return Column(
      children: [
        _buildInfoRow(context, AppIcons.star, contract.businessName),

        SizedBox(height: 6.h),
        _buildInfoRow(
          context,
          AppIcons.star,
          contract.businessType.toLowerCase() == 'company'
              ? AppLocalizations.of(context)!.company
              : AppLocalizations.of(context)!.personal,
        ),
        SizedBox(height: 6.h),
        _buildInfoRow(context, AppIcons.location, contract.businessAddress),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String icon, String text) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            icon,
            width: 14.sp,
            height: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.displayLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildRejectionReason(BuildContext context, AppLocalizations locale) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16.sp, color: Colors.red[700]),
              SizedBox(width: 8.w),
              Text(
                locale.rejected,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.red[700]),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            contract.rejectedReason ?? '',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.red[900]),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      if (dateStr.isEmpty) return '';
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '';
    }
  }
}
