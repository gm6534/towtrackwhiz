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

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/common_app_bar.dart';
import 'package:towtrackwhiz/Core/Common/helper.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Model/Profile/pay_method_list_res_model.dart';
import 'package:towtrackwhiz/Model/earning_res_model.dart';

import '../../Controller/Dashboard/profile_controller.dart';
import '../../Core/Common/Widgets/app_heading_text_field.dart';
import '../../Core/Common/Widgets/base_scaffold.dart';
import '../../Core/Common/validation_helper.dart';
import '../../core/Utils/app_colors.dart';

class PayoutScreen extends GetView<ProfileController> {
  const PayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: commonAppBar,
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: AppColors.primary),
      //   backgroundColor: AppColors.scaffoldBgColor,
      //   surfaceTintColor: AppColors.scaffoldBgColor,
      //   title: Image.asset(ImgPath.appLogo, width: context.width * 0.5),
      //   centerTitle: true,
      // ),
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
                buildPayoutForm(),
                20.verticalSpace,

                AppButton(
                  onPressed: controller.submitPayoutRequest,
                  title: "Make Payout Request",
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

  Widget buildPayoutForm() {
    return Form(
      key: controller.payoutFormKey,
      child: Column(
        children: [
          20.verticalSpace,
          DropdownButtonFormField<PayMethodListResModel>(
            dropdownColor: AppColors.white,
            value: controller.selectedPayoutMethod.value,
            items:
                controller.payMethodList.map((pay) {
                  return DropdownMenuItem(
                    value: pay,
                    child: Text("${pay.name}", style: Get.textTheme.titleSmall),
                  );
                }).toList(),
            onChanged: (value) {
              if (value != controller.selectedPayoutMethod.value) {
                controller.clearPayoutForm();
              }
              controller.selectedPayoutMethod.value = value;
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(12.w),
              filled: true,
              fillColor: AppColors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.greyColor),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.greyColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.greyColor),
              ),
            ),
            icon: Transform.rotate(
              angle: -math.pi / 2,
              child: Icon(Icons.arrow_back_ios, color: Colors.cyan, size: 18.w),
            ),
            isExpanded: true,
          ),
          16.verticalSpace,
          if (controller.methodCode != "") ...[
            /// Amount
            // AppHeadingTextField(
            //   heading: "Amount",
            //   controller: controller.amountController,
            //   hintText: "Enter amount",
            //   textInputType: TextInputType.number,
            //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            //   validator:
            //       (value) => ValidationHelper.validateNonEmpty(value, "Amount"),
            // ),
            AppHeadingTextField(
              heading: "Amount",
              controller: controller.amountController,
              hintText: "Enter amount",
              textInputType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              validator: (value) {
                // 1. Required check
                final requiredError = ValidationHelper.validateNonEmpty(
                  value,
                  "Amount",
                );
                if (requiredError != null) return requiredError;

                // 2. Numeric + Balance check
                final entered = double.tryParse(value ?? "0") ?? 0;
                final available = double.parse(
                  controller.earningResModel.value.data!.amount.toString(),
                );

                if (entered < 1) {
                  return "Minimum amount is 1";
                } else if (entered > available) {
                  return "Amount exceeds available balance ($available)";
                }

                return null;
              },
            ),

            // 16.verticalSpace,
            //
            // /// Notes
            // AppHeadingTextField(
            //   heading: "Notes",
            //   controller: controller.notesController,
            //   hintText: "Optional notes",
            // ),
            16.verticalSpace,
          ],

          /// Dynamic fields
          Obx(() {
            switch (controller.methodCode) {
              case "paypal":
                return AppHeadingTextField(
                  heading: "PayPal Email",
                  controller: controller.paypalEmailController,
                  textInputType: TextInputType.emailAddress,
                  hintText: "Enter PayPal email",
                  validator: (v) => ValidationHelper.validateEmail(v),
                );

              case "payoneer":
                return Column(
                  children: [
                    AppHeadingTextField(
                      heading: "Payoneer Email",
                      controller: controller.payoneerEmailController,
                      hintText: "Enter Payoneer email",
                      textInputType: TextInputType.emailAddress,
                      validator: (v) => ValidationHelper.validateEmail(v),
                    ),
                    12.verticalSpace,
                    AppHeadingTextField(
                      heading: "Payoneer Customer ID",
                      controller: controller.payoneerCustomerIdController,
                      hintText: "Optional",
                    ),
                  ],
                );

              case "bank":
                return Column(
                  children: [
                    AppHeadingTextField(
                      heading: "Account Holder",
                      controller: controller.accountHolderController,
                      hintText: "Enter account holder name",
                      textInputType: TextInputType.name,
                      validator:
                          (value) => ValidationHelper.validateNonEmpty(
                            value,
                            "Account Holder",
                          ),
                    ),
                    12.verticalSpace,
                    AppHeadingTextField(
                      heading: "Bank Name",
                      controller: controller.bankNameController,
                      hintText: "Enter bank name",
                      textInputType: TextInputType.name,
                      validator:
                          (value) => ValidationHelper.validateNonEmpty(
                            value,
                            "Bank Name",
                          ),
                    ),
                    12.verticalSpace,
                    AppHeadingTextField(
                      heading: "Account Number",
                      controller: controller.accountNumberController,
                      hintText: "Enter account number",
                      textInputType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator:
                          (value) => ValidationHelper.validateNonEmpty(
                            value,
                            "Account Number",
                          ),
                    ),
                    12.verticalSpace,
                    AppHeadingTextField(
                      heading: "Routing Number",
                      controller: controller.routingNumberController,
                      hintText: "Enter routing number",
                      validator:
                          (value) => ValidationHelper.validateNonEmpty(
                            value,
                            "Routing Number",
                          ),
                    ),
                    12.verticalSpace,
                    AppHeadingTextField(
                      heading: "Account Type",
                      controller: controller.accountTypeController,
                      hintText: "Checking / Savings",
                      validator:
                          (value) => ValidationHelper.validateNonEmpty(
                            value,
                            "Account Type",
                          ),
                    ),
                  ],
                );

              case "zelle":
              case "cashapp":
                return AppHeadingTextField(
                  heading: "Payout Handle",
                  controller: controller.payoutHandleController,
                  hintText: "Enter username/handle",
                  validator:
                      (value) => ValidationHelper.validateNonEmpty(
                        value,
                        "Payout Handle",
                      ),
                );

              default:
                return const SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }
}
