import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';

class ContractCard extends StatelessWidget {
  final Contract contract;
  final VoidCallback? onTap;

  const ContractCard({
    super.key,
    required this.contract,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlack.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    contract.fullName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                _buildStatusChip(context, contract.status ?? 'pending'),
              ],
            ),
            SizedBox(height: 12.h),
            
            // Contract info
            if (contract.email != null) ...[
              _buildInfoRow(
                context,
                icon: Icons.email_outlined,
                label: 'Email',
                value: contract.email!,
              ),
              SizedBox(height: 8.h),
            ],
            if (contract.phone != null) ...[
              _buildInfoRow(
                context,
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: contract.phone!,
              ),
              SizedBox(height: 8.h),
            ],
            _buildInfoRow(
              context,
              icon: Icons.business_outlined,
              label: 'Business Type',
              value: contract.businessType == 'personal' ? 'Personal' : 'Company',
            ),
            
            if (contract.bankName != null) ...[
              SizedBox(height: 8.h),
              _buildInfoRow(
                context,
                icon: Icons.account_balance_outlined,
                label: 'Bank',
                value: contract.bankName!.split(' - ').first,
              ),
            ],
            
            // Date info
            if (contract.createdAt != null) ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14.sp,
                    color: AppColors.textSubtitle,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Created: ${_formatDate(DateTime.parse(contract.createdAt!))}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSubtitle,
                        ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: AppColors.primaryBlue,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSubtitle,
                      fontSize: 11.sp,
                    ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'approved':
        backgroundColor = AppColors.primaryGreen;
        textColor = AppColors.textSecondary;
        displayText = 'Approved';
        break;
      case 'rejected':
        backgroundColor = AppColors.primaryRed;
        textColor = AppColors.textSecondary;
        displayText = 'Rejected';
        break;
      case 'pending':
      default:
        backgroundColor = AppColors.primaryOrange;
        textColor = AppColors.textSecondary;
        displayText = 'Pending';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        displayText,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
            ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

