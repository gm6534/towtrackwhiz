import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Dashboard/profile_controller.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

class EarningProgressCard extends GetView<ProfileController> {
  const EarningProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final earningResModel = controller.earningResModel.value;
      double progress = ((earningResModel.cycleEarning ?? 0) / 10).clamp(
        0.0,
        1.0,
      );
      if (earningResModel.cycleEarning == null) {
        return SizedBox.shrink();
      }
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.w),
          border: Border.all(color: AppColors.greyColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Amount Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Payout Balance", style: context.textTheme.headlineSmall),
                Text(
                  "\$${earningResModel.cycleEarning?.toStringAsFixed(2)}",
                  style: context.textTheme.titleLarge,
                ),
              ],
            ),

            10.verticalSpace,

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),

            10.verticalSpace,

            // Next payout text
            Text(
              "Next payout at \$10",
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.hintColor,
              ),
            ),
          ],
        ),
      );
    });
  }
}
