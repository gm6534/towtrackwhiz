// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
// import 'package:towtrackwhiz/Model/earning_res_model.dart';
//
// import '../../Controller/Dashboard/profile_controller.dart';
// import '../../Core/Common/Widgets/base_scaffold.dart';
// import '../../core/Utils/app_colors.dart';
//
// class PayoutScreen extends GetView<ProfileController> {
//   const PayoutScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: AppColors.primary),
//         backgroundColor: AppColors.scaffoldBgColor,
//         surfaceTintColor: AppColors.scaffoldBgColor,
//         title: Image.asset(ImgPath.appLogo, width: context.width * 0.5),
//       ),
//       body: Obx(() {
//         if (controller.isPayoutLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         Earnings? data = controller.earningResModel.value.data;
//         if (data == null) {
//           return Center(
//             child: Text(Strings.noEarning, style: context.textTheme.titleLarge),
//           );
//         }
//
//         final amount = double.parse(data.amount!);
//         // final amount = 10;
//         final progress = (amount / 30).clamp(0.0, 1.0);
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           spacing: 10.w,
//           children: [
//             Text(
//               AppHeadings.paymentMethod,
//               style: Get.textTheme.headlineMedium,
//             ),
//             50.verticalSpace,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // left fixed label
//                 Text("0\$", style: context.textTheme.titleLarge),
//                 Text("10\$", style: context.textTheme.titleLarge),
//                 Text("20\$", style: context.textTheme.titleLarge),
//                 // Expanded(
//                 //   child:
//                 //       (amount >= 5 && amount <= 25)
//                 //           ? AnimatedAlign(
//                 //             duration: const Duration(milliseconds: 400),
//                 //             curve: Curves.easeInOut,
//                 //             alignment: Alignment((progress * 2) - 1, -1.8),
//                 //             child: Text(
//                 //               "\$${amount.toStringAsFixed(0)}",
//                 //               style: context.textTheme.titleLarge?.copyWith(
//                 //                 fontWeight: FontWeight.bold,
//                 //                 color: Colors.black,
//                 //               ),
//                 //             ),
//                 //           )
//                 //           : SizedBox.shrink(),
//                 // ),
//
//                 // right fixed label
//                 Text("30\$", style: context.textTheme.titleLarge),
//               ],
//             ),
//
//             LinearProgressIndicator(
//               value: progress,
//               backgroundColor: AppColors.lightGreyColor,
//               valueColor: const AlwaysStoppedAnimation(AppColors.primary),
//               minHeight: 12.h,
//               borderRadius: BorderRadius.circular(12.r),
//             ),
//             5.verticalSpace,
//             Container(
//               margin: EdgeInsets.only(top: 12.h),
//               child: Text(
//                 "Current Balance: \$${amount.toStringAsFixed(2)}",
//                 style: context.textTheme.titleLarge,
//               ),
//             ),
//             5.verticalSpace,
//
//             // Conditionally show message
//             if (amount >= 10)
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.all(12.w),
//                 decoration: BoxDecoration(
//                   color: AppColors.lightYellowColor,
//                   borderRadius: BorderRadius.circular(8.r),
//                 ),
//                 child: Row(
//                   spacing: 10.w,
//                   children: [
//                     Image.asset(ImgPath.badgeIcon, height: 30.w),
//                     Expanded(
//                       child: Text(
//                         "\"You’ve reached \$10! Choose payout method.\"",
//                         style: context.textTheme.bodyMedium,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         );
//       }),
//     );
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Common/helper.dart';
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
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isPayoutLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final earnings = controller.earningResModel.value;
        Earnings? data = earnings.data;
        if (data == null) {
          return Center(
            child: Text(Strings.noEarning, style: context.textTheme.titleLarge),
          );
        }

        final amount = double.tryParse(data.amount ?? "0") ?? 0.0;
        // final amount = 10;
        final lifetime = double.tryParse(earnings.totalEarning ?? "0") ?? 0.0;
        const maxPayout = 10.0;

        final progress = (amount / maxPayout).clamp(0.0, 1.0);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppHeadings.payoutMethod,
                style: Get.textTheme.headlineMedium,
              ),
              20.verticalSpace,
              Center(
                child: Text(
                  "You're in ${Helper.getOrdinal(earnings.rank ?? 0)} place to earn the \$10 payout!",
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              6.verticalSpace,
              Center(
                child: Text(
                  "Remember, only the first 50 users are eligible.",
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
              30.verticalSpace,

              // Progress bar with truck
              // Progress bar with truck (animated)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: progress),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Container(
                    margin: EdgeInsets.zero,
                    height: 30.w,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        // Progress bar background
                        LinearProgressIndicator(
                          value: value, // <-- use animated value here
                          backgroundColor: AppColors.lightGreyColor,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.primary,
                          ),
                          minHeight: 12.h,
                          borderRadius: BorderRadius.circular(12.r),
                        ),

                        // Truck icon synced with progress
                        Positioned(
                          left: (context.width - 90.w) * value,
                          child: Image.asset(
                            ImgPath.truckIcon,
                            height: 25.w,
                            width: 50.w,
                            // color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              30.verticalSpace,

              Center(
                child: Text(
                  "\$${amount.toStringAsFixed(2)}",
                  style: context.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              6.verticalSpace,
              Center(
                child: Text(
                  "Lifetime earned: \$${lifetime.toStringAsFixed(2)}",
                  style: context.textTheme.titleLarge?.copyWith(
                    color: AppColors.greyColor,
                  ),
                ),
              ),
              20.verticalSpace,

              if (amount >= maxPayout)
                Container(
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
              20.verticalSpace,
              Column(
                spacing: 10.w,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildRewardItem("Verified Alert", "\$0.50"),
                  _buildRewardItem("Unverified Alert (no image)", "\$0.10"),
                  _buildRewardItem("Max per user", "\$10"),
                ],
              ),

              if (amount >= maxPayout) ...[
                20.verticalSpace,
                ListTile(
                  tileColor: AppColors.white,
                  minLeadingWidth: 0,
                  contentPadding: EdgeInsets.symmetric(horizontal: 5.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  title: Text(
                    "Select Payment Method",
                    style: context.textTheme.titleLarge,
                  ),
                  trailing: Transform.rotate(
                    angle: 90 * pi / 180,
                    child: Image.asset(ImgPath.downArrow, height: 20.w),
                  ),
                ),
                10.verticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    spacing: 10.w,
                    children: [
                      _buildPaymentOption(
                        icon: Icons.account_balance_wallet,
                        title: 'Venmo',
                        color: AppColors.black,
                      ),
                      _buildPaymentOption(
                        icon: Icons.payment,
                        title: 'PayPal',
                        color: AppColors.black,
                      ),
                      _buildPaymentOption(
                        icon: Icons.mobile_friendly,
                        title: 'Cash App',
                        color: AppColors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRewardItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Get.textTheme.bodyLarge),
        Text(
          value,
          style: Get.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      spacing: 10.w,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Flexible(child: Text(title, style: Get.textTheme.titleMedium)),
      ],
    );
  }
}
