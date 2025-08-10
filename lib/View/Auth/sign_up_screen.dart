import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:towtrackwhiz/Controller/Auth/sign_up_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart'
    show AppButton;
import 'package:towtrackwhiz/Core/Common/Widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:towtrackwhiz/Core/Common/validation_helper.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.w),
          child: Form(
            key: controller.signUpFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                35.verticalSpace,
                Image.asset(ImgPath.appLogo),
                10.verticalSpace,
                Text(
                  AppHeadings.signUpTitle,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.headlineSmall?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                50.verticalSpace,
                AppTextField(
                  label: 'Email',
                  controller: controller.emailController,
                  prefix: Icon(Icons.email, color: AppColors.primary),
                  hintText: "login_hint".tr,
                  validator: (value) => ValidationHelper.validateEmail(value),
                ),
                30.verticalSpace,

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

                Spacer(),
                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: AppButton(
                    onPressed: () => controller.signUpPage(),
                    title: ActionText.singUp,
                    
                  ),
                ),
                15.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Have an account? "),
                    GestureDetector(
                      onTap: controller.loginPage,
                      child: const Text(
                        ActionText.login,
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
