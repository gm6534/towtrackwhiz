import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Other/reset_pass_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_text_field.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';
import 'package:towtrackwhiz/Core/Common/validation_helper.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

class ResetPassScreen extends GetView<ResetPassController> {
  const ResetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Form(
        key: controller.resetPassFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            30.verticalSpace,
            Text(
              AppHeadings.resetPassTitle,
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
              AppHeadings.resetPassSubTitle,
              textAlign: TextAlign.center,
              style: Get.textTheme.headlineSmall?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),

            50.verticalSpace,
            Obx(() {
                  return AppTextField(
                    label: 'Password',
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    prefix: Icon(Icons.lock, color: AppColors.primary),
                    suffix: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.primary,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    hintText: "**********",
                    validator:
                        (value) => ValidationHelper.validatePassword(value),
                  );
                }),
                30.verticalSpace,
                Obx(() {
                  return AppTextField(
                    label: 'Confirm Password',
                    controller: controller.passwordConfirmController,
                    obscureText: !controller.isConfirmVisible.value,
                    prefix: Icon(Icons.lock, color: AppColors.primary),
                    suffix: IconButton(
                      icon: Icon(
                        controller.isConfirmVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.primary,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    hintText: "**********",
                    validator:
                        (value) => ValidationHelper.validateConfirmPassword(
                          controller.passwordController.value.toString(),
                          value,
                        ),
                  );
                }),


            30.verticalSpace,

            Spacer(),
            // Sign In Button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: AppButton(
                onPressed: () => controller.save(),
                title: ActionText.save,
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}