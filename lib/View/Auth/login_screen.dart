import 'package:towtrackwhiz/Controller/Auth/login_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_text_field.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_web_view.dart';
import 'package:towtrackwhiz/Core/Common/validation_helper.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: controller.loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                35.verticalSpace,
                Image.asset(ImgPath.appLogo, width: 300.w),
                10.verticalSpace,
                // Align(
                //   alignment: AlignmentDirectional.center,
                //   child: Text(
                //     "Welcome to TowTrackWhiz",
                //     style: Get.textTheme.headlineSmall?.copyWith(
                //       fontWeight: FontWeight.w600,
                //       color: Colors.black,
                //     ),
                //   ),
                // ),
                // Align(
                //   alignment: AlignmentDirectional.center,
                //   child: Text(
                //     "Assist users in locating towed vehicles",
                //     style: Get.textTheme.headlineSmall?.copyWith(
                //       fontWeight: FontWeight.w600,
                //       color: Colors.black,
                //     ),
                //   ),
                // ),
                Text(
                  AppHeadings.signInTitle,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.headlineSmall,

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

                Spacer(),
                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: AppButton(
                    onPressed: controller.login,
                    title: ActionText.login,
                  ),
                ),
                15.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t have an account? "),
                    GestureDetector(
                      onTap: controller.signUp,
                      child: const Text(
                        ActionText.singUp,
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
