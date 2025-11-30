import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_params.dart';

class ContractCard extends StatelessWidget {
  final Contract contract;
  final VoidCallback? onTap;

  const ContractCard({super.key, required this.contract, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.15),
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: 16.h),
            Divider(
              height: 1,
              color: AppColors.primaryBlue.withOpacity(0.08),
            ),
            SizedBox(height: 16.h),
            _buildInfoGrid(context),
            if (contract.createdAt != null) ...[
              SizedBox(height: 16.h),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16.sp,
                    color: AppColors.textSubtitle,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Tạo ngày ${_formatDate(contract.createdAt!)}',
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(
            Icons.assignment_ind_outlined,
            color: AppColors.primaryBlue,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contract.user?.fullName ??
                    contract.user?.email ??
                    'Contract #${contract.id}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Text(
                contract.user?.email ?? 'ID: ${contract.id}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        _buildStatusChip(context, contract.status),
      ],
    );
  }

  Widget _buildInfoGrid(BuildContext context) {
    final infoChips = <Widget>[
      if (contract.user?.phone != null)
        _InfoChip(
          icon: Icons.phone_outlined,
          label: AppLocalizations.of(context)!.phoneNumber,
          value: contract.user!.phone!,
        ),
      if (contract.bankName != null)
        _InfoChip(
          icon: Icons.account_balance_outlined,
          label: AppLocalizations.of(context)!.bank,
          value: contract.bankName!.split(' - ').first,
        ),
      _InfoChip(
        icon: Icons.business_center_outlined,
        label: AppLocalizations.of(context)!.businessTypeLabel,
        value:
            contract.businessType == BusinessType.personal ? AppLocalizations.of(context)!.personal : AppLocalizations.of(context)!.company,
      ),
      if (contract.taxCode?.isNotEmpty ?? false)
        _InfoChip(
          icon: Icons.edit_note_outlined,
          label: AppLocalizations.of(context)!.taxCode,
          value: contract.taxCode!,
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final chipWidth = (constraints.maxWidth - 12.w) / 2;
        return Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children:
              infoChips
                  .map(
                    (chip) => SizedBox(
                      width: chipWidth,
                      child: chip,
                    ),
                  )
                  .toList(),
        );
      },
    );
  }

  Widget _buildStatusChip(BuildContext context, RentalContractStatus status) {
    Color backgroundColor;
    String displayText;

    switch (status) {
      case RentalContractStatus.approved:
        backgroundColor = AppColors.primaryGreen;
        displayText = 'Approved';
        break;
      case RentalContractStatus.rejected:
        backgroundColor = AppColors.primaryRed;
        displayText = 'Rejected';
        break;
      case RentalContractStatus.pending:
        backgroundColor = AppColors.primaryOrange;
        displayText = 'Pending';
        break;
      case RentalContractStatus.suspended:
        backgroundColor = AppColors.primaryGrey;
        displayText = 'Suspended';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        displayText,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryWhite,
            ),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16.sp, color: AppColors.primaryBlue),
              SizedBox(width: 6.w),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

