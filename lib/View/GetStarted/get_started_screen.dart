import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Other/get_started_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';

class GetStartedScreen extends GetView<GetStartedController> {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10.w,
            children: [
              50.verticalSpace,
              Image.asset(ImgPath.appLogo, width: 300.w),
              Text(
                "Let's Get Started",
                style: Get.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Expanded(child: Image.asset(ImgPath.tow3Png)),
              AppButton(
                onPressed: () => controller.loginPage(),
                title: controller.login,
              ),
              AppButton(
                onPressed: () => controller.signUpPage(),
                isOutlined: true,
                title: controller.signUp,
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
