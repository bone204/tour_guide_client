import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract.dart';
import 'package:tour_guide_app/features/my_vehicle/data/models/contract_params.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/contract_detail/contract_detail_cubit.dart';
import 'package:tour_guide_app/features/my_vehicle/presentation/bloc/contract_detail/contract_detail_state.dart';

class ContractDetailPage extends StatefulWidget {
  final int contractId;

  const ContractDetailPage({super.key, required this.contractId});

  @override
  State<ContractDetailPage> createState() => _ContractDetailPageState();
}

class _ContractDetailPageState extends State<ContractDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContractDetailCubit>().fetchContract(widget.contractId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Contract #${widget.contractId}',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: BlocBuilder<ContractDetailCubit, ContractDetailState>(
        builder: (context, state) {
          if (state is ContractDetailLoading || state is ContractDetailInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContractDetailFailure) {
            return _buildErrorState(state.message);
          } else if (state is ContractDetailSuccess) {
            return _buildDetail(state.contract);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: AppColors.primaryRed),
            SizedBox(height: 16.h),
            Text(
              'Không thể tải hợp đồng',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSubtitle,
                  ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => context.read<ContractDetailCubit>().fetchContract(
                    widget.contractId,
                  ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.primaryWhite,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(Contract contract) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(contract),
          SizedBox(height: 20.h),
          _buildSection(
            'Thông tin chủ hợp đồng',
            [
              _InfoTile(
                label: 'Họ và tên',
                value: contract.user?.fullName ?? '—',
                icon: Icons.person_outline,
              ),
              _InfoTile(
                label: 'Email',
                value: contract.user?.email ?? '—',
                icon: Icons.email_outlined,
              ),
              _InfoTile(
                label: 'Số điện thoại',
                value: contract.user?.phone ?? '—',
                icon: Icons.phone_outlined,
              ),
              _InfoTile(
                label: 'CMND/CCCD',
                value: contract.citizenId ?? '—',
                icon: Icons.badge_outlined,
              ),
            ],
          ),
          _buildSection(
            'Thông tin kinh doanh',
            [
              _InfoTile(
                label: 'Loại hình',
                value: contract.businessType == BusinessType.personal
                    ? 'Cá nhân'
                    : 'Doanh nghiệp',
                icon: Icons.store_mall_directory_outlined,
              ),
              _InfoTile(
                label: 'Tên doanh nghiệp',
                value: contract.businessName ?? '—',
                icon: Icons.corporate_fare_outlined,
              ),
              _InfoTile(
                label: 'Địa chỉ',
                value: contract.businessAddress ??
                    contract.businessProvince ??
                    '—',
                icon: Icons.location_on_outlined,
              ),
              _InfoTile(
                label: 'Mã số thuế',
                value: contract.taxCode ?? '—',
                icon: Icons.confirmation_number_outlined,
              ),
            ],
          ),
          _buildSection(
            'Thông tin ngân hàng',
            [
              _InfoTile(
                label: 'Ngân hàng',
                value: contract.bankName ?? '—',
                icon: Icons.account_balance_outlined,
              ),
              _InfoTile(
                label: 'Chủ tài khoản',
                value: contract.bankAccountName ?? '—',
                icon: Icons.person_pin_circle_outlined,
              ),
              _InfoTile(
                label: 'Số tài khoản',
                value: contract.bankAccountNumber ?? '—',
                icon: Icons.numbers,
              ),
            ],
          ),
          if ((contract.notes?.isNotEmpty ?? false) ||
              (contract.rejectedReason?.isNotEmpty ?? false))
            _buildSection(
              'Ghi chú & Trạng thái',
              [
                if (contract.notes?.isNotEmpty ?? false)
                  _InfoTile(
                    label: 'Ghi chú',
                    value: contract.notes!,
                    icon: Icons.note_outlined,
                  ),
                if (contract.status == RentalContractStatus.rejected &&
                    (contract.rejectedReason?.isNotEmpty ?? false))
                  _InfoTile(
                    label: 'Lý do từ chối',
                    value: contract.rejectedReason!,
                    icon: Icons.report_gmailerrorred_outlined,
                  ),
                _InfoTile(
                  label: 'Cập nhật lần cuối',
                  value: contract.updatedAt != null
                      ? _formatDate(contract.updatedAt!)
                      : '—',
                  icon: Icons.schedule_outlined,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(Contract contract) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue,
            AppColors.primaryBlue.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contract.user?.fullName ??
                contract.user?.email ??
                'Rental Contract #${contract.id}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Mã hợp đồng: ${contract.id}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
          SizedBox(height: 16.h),
          Align(
            alignment: Alignment.centerLeft,
            child: _StatusChip(
              status: contract.status,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          SizedBox(height: 16.h),
          ...children.expand(
            (widget) => [widget, SizedBox(height: 14.h)],
          ).toList()
            ..removeLast(),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

class _StatusChip extends StatelessWidget {
  final RentalContractStatus status;
  final EdgeInsets padding;

  const _StatusChip({required this.status, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor = Colors.white;
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
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Text(
        displayText,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryBlue,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSubtitle,
                    ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

