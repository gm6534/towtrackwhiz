import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Other/forget_password_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_text_field.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';
import 'package:towtrackwhiz/Core/Common/validation_helper.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

class ForgetPasswordScreen extends GetView<ForgetPasswordController> {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Form(
        key: controller.forgetPassFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            30.verticalSpace,
            Text(
              AppHeadings.forgetPassTitle,
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
              AppHeadings.forgetPassSubTitle,
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
              hintText: "Jhon@gmail.com",
              validator: (value) => ValidationHelper.validateEmail(value),
            ),
            30.verticalSpace,

            Spacer(),
            // Sign In Button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: AppButton(
                onPressed: () => controller.sendCode(),
                title: ActionText.sendCode,
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}
