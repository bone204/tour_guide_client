import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/core/utils/date_formatter.dart';
import 'package:tour_guide_app/core/utils/money_formatter.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/get_rental_bill_detail/get_rental_bill_detail_cubit.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/bloc/get_rental_bill_detail/rental_bill_detail_state.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/features/bills/rental_vehicle/presentation/widgets/rental_bill_detail_shimmer.dart';

class RentalBillDetailPage extends StatelessWidget {
  final int id;

  const RentalBillDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GetRentalBillDetailCubit>()..getBillDetail(id),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.rentalBillDetail),
          centerTitle: true,
        ),
        body: BlocBuilder<GetRentalBillDetailCubit, RentalBillDetailState>(
          builder: (context, state) {
            if (state.status == RentalBillDetailInitStatus.loading) {
              return const RentalBillDetailShimmer();
            } else if (state.status == RentalBillDetailInitStatus.failure) {
              return Center(child: Text(state.errorMessage ?? 'Error'));
            } else if (state.status == RentalBillDetailInitStatus.success &&
                state.bill != null) {
              final bill = state.bill!;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      context,
                      title: AppLocalizations.of(context)!.status,
                      content: Text(
                        bill.status.name
                            .toUpperCase(), // Improve localization later
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppColors.primaryBlue),
                      ),
                    ),
                    const Divider(),
                    _buildInfoRow(
                      context,
                      AppLocalizations.of(context)!.billCode,
                      bill.code,
                    ),
                    _buildInfoRow(
                      context,
                      AppLocalizations.of(context)!.startDate,
                      DateFormatter.formatDate(bill.startDate),
                    ),
                    _buildInfoRow(
                      context,
                      AppLocalizations.of(context)!.endDate,
                      DateFormatter.formatDate(bill.endDate),
                    ),
                    _buildInfoRow(
                      context,
                      AppLocalizations.of(context)!.totalPayment,
                      Formatter.currency(bill.total),
                      isBold: true,
                      color: AppColors.primaryRed,
                    ),
                    const Divider(),
                    if (bill.details.isNotEmpty) ...[
                      Text(
                        AppLocalizations.of(context)!.vehicleList,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 8.h),
                      ...bill.details.map(
                        (detail) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.two_wheeler),
                            title: Text(detail.licensePlate),
                            trailing: Text(Formatter.currency(detail.price)),
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                    if (bill.notes != null && bill.notes!.isNotEmpty)
                      _buildInfoRow(
                        context,
                        AppLocalizations.of(context)!.notes,
                        bill.notes!,
                      ),
                    if (bill.contactName != null)
                      _buildInfoRow(
                        context,
                        AppLocalizations.of(context)!.contactInfo,
                        '${bill.contactName} - ${bill.contactPhone}',
                      ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
        SizedBox(height: 4.h),
        content,
        SizedBox(height: 12.h),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
