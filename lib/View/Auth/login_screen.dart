import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Auth/login_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_web_view.dart';
import 'package:towtrackwhiz/Core/Common/validation_helper.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

import '../../Core/Common/Widgets/app_heading_text_field.dart';

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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20.w,
                children: [
                  20.verticalSpace,
                  Image.asset(ImgPath.appLogo, height: 80.w),
                  Text(
                    AppHeadings.signInTitle,
                    textAlign: TextAlign.center,
                    style: Get.textTheme.labelLarge,
                  ),

                  20.verticalSpace,
                  AppHeadingTextField(
                    heading: AppHeadings.email,
                    controller: controller.emailController,
                    prefix: Container(
                      margin: EdgeInsets.all(12.w),
                      child: Image.asset(
                        ImgPath.msgIcon,
                        height: 10.w,
                        width: 10.w,
                      ),
                    ),
                    hintText: Strings.enterEmailHere,
                    validator: (value) => ValidationHelper.validateEmail(value),
                  ),

                  Obx(() {
                    return AppHeadingTextField(
                      heading: AppHeadings.password,
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      prefix: Container(
                        margin: EdgeInsets.all(15.w),
                        child: Image.asset(
                          ImgPath.passIcon,
                          height: 10.w,
                          width: 10.w,
                        ),
                      ),
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.to(
                          () => AppWebView(
                            fileUrl:
                                "https://towtrack.devdioxide.com/forgot-password",
                            barTitle: AppHeadings.forgetPassTitle,
                          ),
                        );
                      },
                      child: Text(AppHeadings.forgetPassBtnTitle),
                    ),
                  ),
                  // SizedBox(height: context.width * 0.1),
                  AppButton(
                    onPressed: controller.login,
                    title: ActionText.signIn,
                  ),
                  Row(
                    spacing: 16.w,
                    children: [
                      const Expanded(child: Divider(height: 0, thickness: 1)),
                      Center(
                        child: Text(
                          Strings.orContinueWithText,
                          style: context.textTheme.bodyMedium,
                        ),
                      ),
                      const Expanded(child: Divider(height: 0, thickness: 1)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    spacing: 5.w,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.signInWithGoogle,
                          child: Row(
                            spacing: 10.w,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Strings.continueWith,
                                style: context.textTheme.titleMedium?.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              Image.asset(
                                ImgPath.googleIcon,
                                height: context.height * 0.03,
                              ),
                            ],
                          ),
                        ),
                      ),

                      if (GetPlatform.isIOS)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: controller.signInWithApple,
                            child: Row(
                              spacing: 10.w,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Strings.continueWith,
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(color: AppColors.primary),
                                ),
                                Image.asset(
                                  ImgPath.appleIcon,
                                  height: context.height * 0.03,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Strings.dontHaveAccount,
                        style: Get.textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: controller.signUp,
                        child: Text(
                          ActionText.singUp,
                          style: Get.textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: SafeArea(
        //   child: Padding(
        //     padding: EdgeInsets.all(16.w),
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       spacing: 10.w,
        //       children: [
        //         AppButton(onPressed: controller.login, title: ActionText.login),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Text(
        //               "Don’t have an account? ",
        //               style: Get.textTheme.bodyMedium,
        //             ),
        //             GestureDetector(
        //               onTap: controller.signUp,
        //               child: Text(
        //                 ActionText.singUp,
        //                 style: Get.textTheme.titleMedium?.copyWith(
        //                   color: AppColors.primary,
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
