import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Auth/sign_up_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart'
    show AppButton;
import 'package:towtrackwhiz/Core/Common/Widgets/app_heading_text_field.dart';
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15.w,
                children: [
                  5.verticalSpace,
                  Image.asset(ImgPath.appLogo),
                  Text(
                    AppHeadings.signUpTitle,
                    textAlign: TextAlign.center,
                    style: Get.textTheme.headlineSmall?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  10.verticalSpace,
                  AppHeadingTextField(
                    heading: AppHeadings.name,
                    controller: controller.nameController,
                    prefix: Icon(Icons.person, color: AppColors.primary),
                    hintText: Strings.enterNameHere,
                    validator:
                        (value) => ValidationHelper.validateName(value, "Name"),
                  ),
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
                  Obx(() {
                    return AppHeadingTextField(
                      heading: AppHeadings.confirmPassword,
                      controller: controller.passwordConfirmController,
                      obscureText: !controller.isConfirmVisible.value,
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
                            controller.passwordController.text,
                            value,
                          ),
                    );
                  }),
                  SizedBox(height: context.width * 0.04),
                  AppButton(
                    onPressed: controller.signUp,
                    title: ActionText.singUp,
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
                        Strings.haveAnAccount,
                        style: Get.textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: controller.loginPage,
                        child: Text(
                          ActionText.signIn,
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
      ),
    );
  }
}
