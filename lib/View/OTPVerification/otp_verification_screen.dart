import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Other/otp_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_text_field.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/otp_box.dart';
import 'package:towtrackwhiz/Core/Common/validation_helper.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

class OtpVerificationScreen extends GetView<OtpController> {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Form(
        key: controller.otpFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            30.verticalSpace,
            Text(
              AppHeadings.otpTitle,
              textAlign: TextAlign.center,
              style: Get.textTheme.headlineLarge?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            5.verticalSpace,
            Image.asset(ImgPath.appLogo),
            10.verticalSpace,
            Text(
              AppHeadings.otpSubTitle,
              textAlign: TextAlign.center,
              style: Get.textTheme.headlineSmall?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            50.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => OtpBox(
                  controller: controller.otpControllers[index],
                  index: index,
                  allControllers: controller.otpControllers,
                ),  
              ),
            ),

            Spacer(),
            // Sign In Button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: AppButton(
                onPressed: () => controller.submit(),
                title: ActionText.submit,
                
              ),
            ),

            15.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don’t Receive the Code?  "),
                GestureDetector(
                  onTap: controller.resendCode,
                  child: const Text(
                    ActionText.resendCode,
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
