import 'package:towtrackwhiz/Controller/Auth/login_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_text_field.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_web_view.dart';
import 'package:towtrackwhiz/Core/Common/validation_helper.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: controller.loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20.w,
                  children: [
                    20.verticalSpace,
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "login_headline".tr,
                        style: Get.textTheme.displaySmall?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    30.verticalSpace,
                    AppTextField(
                      controller: controller.emailController,
                      prefix: Icon(Icons.email_outlined),
                      hintText: "login_hint".tr,
                      validator:
                          (value) => ValidationHelper.validateEmail(value),
                    ),

                    Obx(() {
                      return AppTextField(
                        controller: controller.passwordController,
                        obscureText: !controller.isPasswordVisible.value,
                        prefix: Icon(Icons.lock_outline),
                        suffix: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                        hintText: "**********",
                        validator:
                            (value) => ValidationHelper.validatePassword(value),
                      );
                    }),

                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runAlignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 10.w,
                      runSpacing: 10.w,
                      children: [
                        SizedBox(
                          width: context.width * 0.45,
                          child: Obx(() {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: controller.isRememberMe.value,
                                  onChanged: controller.toggleRememberMe,
                                  activeColor: AppColors.primary,
                                ),
                                Text(
                                  "remember_me".tr,
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(
                              () => AppWebView(
                                fileUrl:
                                    "https://cleanly.dynamicdev.tech/forgot-password",
                                barTitle: "reset_pass".tr,
                              ),
                            );
                          },
                          child: Text(
                            "forgot_password".tr,
                            style: Get.textTheme.bodyMedium?.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),

                    30.verticalSpace,
                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: AppButton(
                        onPressed: controller.login,
                        isOutlined: true,
                        title: "sign_in".tr,
                      ),
                    ),
                    30.verticalSpace,

                    // // Sign Up Text
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       "dont_have_account".tr,
                    //       style: Get.textTheme.bodyMedium?.copyWith(
                    //         color: AppColors.black,
                    //       ),
                    //     ),
                    //     TextButton(
                    //       onPressed: () {},
                    //       child: Text(
                    //         "sign_up".tr,
                    //         style: Get.textTheme.bodyMedium?.copyWith(
                    //           color: AppColors.primary,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
