import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:towtrackwhiz/Controller/Dashboard/profile_controller.dart';

import '../../Core/Utils/app_colors.dart';

class PayoutHistoryScreen extends GetView<ProfileController> {
  const PayoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isPayoutHistoryLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.payoutHistory.isEmpty) {
        return Center(
          child: Text(
            "No payout history found",
            style: context.textTheme.titleLarge,
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 16.w),
        itemCount: controller.payoutHistory.length,
        itemBuilder: (context, index) {
          final payout = controller.payoutHistory[index];
          final statusColor =
              payout.status?.toLowerCase() == "completed"
                  ? AppColors.greenColor
                  : AppColors.warningColor;

          String formattedDate = "-";
          if (payout.createdAt != null) {
            try {
              formattedDate = DateFormat(
                "yyyy-MM-dd",
              ).format(DateTime.parse(payout.createdAt!));
            } catch (_) {}
          }

          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount + Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${payout.amount ?? "0"}",
                      style: context.textTheme.headlineSmall?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        payout.status?.capitalizeFirst ?? "Unknown",
                        style: context.textTheme.labelLarge?.copyWith(
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),

                // Method
                Text(
                  "Method: ${payout.payoutMethod?.capitalizeFirst ?? "-"}",
                  style: context.textTheme.bodyMedium,
                ),

                // Paypal
                if (payout.paypalEmail != null &&
                    payout.paypalEmail!.isNotEmpty)
                  Text(
                    "PayPal: ${payout.paypalEmail}",
                    style: context.textTheme.bodyMedium,
                  ),

                // Payoneer
                if (payout.payoneerEmail != null &&
                    payout.payoneerEmail.toString().isNotEmpty)
                  Text(
                    "Payoneer: ${payout.payoneerEmail}",
                    style: context.textTheme.bodyMedium,
                  ),
                if (payout.payoneerCustomerId != null)
                  Text(
                    "Payoneer ID: ${payout.payoneerCustomerId}",
                    style: context.textTheme.bodyMedium,
                  ),

                // Bank
                if (payout.bankName != null &&
                    payout.bankName.toString().isNotEmpty)
                  Text(
                    "Bank: ${payout.bankName} (${payout.routingNumber ?? "-"})",
                    style: context.textTheme.bodyMedium,
                  ),
                if (payout.accountHolder != null &&
                    payout.accountHolder.toString().isNotEmpty)
                  Text(
                    "Account Holder: ${payout.accountHolder}",
                    style: context.textTheme.bodyMedium,
                  ),
                if (payout.accountNumber != null &&
                    payout.accountNumber.toString().isNotEmpty)
                  Text(
                    "Account #: ${payout.accountNumber}",
                    style: context.textTheme.bodyMedium,
                  ),
                if (payout.accountType != null &&
                    payout.accountType.toString().isNotEmpty)
                  Text(
                    "Account Type: ${payout.accountType}",
                    style: context.textTheme.bodyMedium,
                  ),

                // Transaction Id
                if (payout.transactionId != null &&
                    payout.transactionId.toString().isNotEmpty)
                  Text(
                    "Txn ID: ${payout.transactionId}",
                    style: context.textTheme.bodyMedium,
                  ),

                // Notes
                if (payout.notes != null && payout.notes.toString().isNotEmpty)
                  Text(
                    "Notes: ${payout.notes}",
                    style: context.textTheme.bodyMedium,
                  ),

                SizedBox(height: 6.h),

                // Date
                Text(
                  "Date: $formattedDate",
                  style: context.textTheme.titleSmall?.copyWith(
                    color: AppColors.greyColor.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
