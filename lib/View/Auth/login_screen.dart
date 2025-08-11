import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Auth/login_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
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
                  30.verticalSpace,
                  Image.asset(ImgPath.appLogo, width: 300.w),
                  Text(
                    AppHeadings.signInTitle,
                    textAlign: TextAlign.center,
                    style: Get.textTheme.headlineSmall,
                  ),

                  40.verticalSpace,
                  AppHeadingTextField(
                    heading: 'Email',
                    controller: controller.emailController,
                    prefix: Container(
                      margin: EdgeInsets.all(12.w),
                      child: Image.asset(
                        ImgPath.msgIcon,
                        height: 10.w,
                        width: 10.w,
                      ),
                    ),
                    hintText: "login_hint".tr,
                    validator: (value) => ValidationHelper.validateEmail(value),
                  ),

                  Obx(() {
                    return AppHeadingTextField(
                      heading: 'Password',
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
                      onPressed: () {},
                      child: Text(AppHeadings.forgetPassBtnTitle),
                    ),
                  ),
                  SizedBox(height: context.width * 0.1),
                  AppButton(
                    onPressed: controller.login,
                    title: ActionText.signIn,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t have an account? ",
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
