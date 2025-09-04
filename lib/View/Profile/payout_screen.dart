import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Model/earning_res_model.dart';

import '../../Controller/Dashboard/profile_controller.dart';
import '../../Core/Common/Widgets/base_scaffold.dart';
import '../../core/Utils/app_colors.dart';

class PayoutScreen extends GetView<ProfileController> {
  const PayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.primary),
        backgroundColor: AppColors.scaffoldBgColor,
        surfaceTintColor: AppColors.scaffoldBgColor,
        title: Image.asset(ImgPath.appLogo, width: context.width * 0.5),
      ),
      body: Obx(() {
        if (controller.isPayoutLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        Earnings? data = controller.earningResModel.value.data;
        if (data == null) {
          return Center(
            child: Text(Strings.noEarning, style: context.textTheme.titleLarge),
          );
        }

        final amount = double.parse(data.amount!);
        // final amount = 10;
        final progress = (amount / 30).clamp(0.0, 1.0);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10.w,
          children: [
            Text(
              AppHeadings.paymentMethod,
              style: Get.textTheme.headlineMedium,
            ),
            50.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // left fixed label
                Text("0\$", style: context.textTheme.titleLarge),
                Text("10\$", style: context.textTheme.titleLarge),
                Text("20\$", style: context.textTheme.titleLarge),
                // Expanded(
                //   child:
                //       (amount >= 5 && amount <= 25)
                //           ? AnimatedAlign(
                //             duration: const Duration(milliseconds: 400),
                //             curve: Curves.easeInOut,
                //             alignment: Alignment((progress * 2) - 1, -1.8),
                //             child: Text(
                //               "\$${amount.toStringAsFixed(0)}",
                //               style: context.textTheme.titleLarge?.copyWith(
                //                 fontWeight: FontWeight.bold,
                //                 color: Colors.black,
                //               ),
                //             ),
                //           )
                //           : SizedBox.shrink(),
                // ),

                // right fixed label
                Text("30\$", style: context.textTheme.titleLarge),
              ],
            ),

            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.lightGreyColor,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 12.h,
              borderRadius: BorderRadius.circular(12.r),
            ),
            5.verticalSpace,
            Container(
              margin: EdgeInsets.only(top: 12.h),
              child: Text(
                "Current Balance: \$${amount.toStringAsFixed(2)}",
                style: context.textTheme.titleLarge,
              ),
            ),
            5.verticalSpace,

            // Conditionally show message
            if (amount >= 10)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.lightYellowColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  spacing: 10.w,
                  children: [
                    Image.asset(ImgPath.badgeIcon, height: 30.w),
                    Expanded(
                      child: Text(
                        "\"You’ve reached \$10! Choose payout method.\"",
                        style: context.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }
}
