import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Other/get_started_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              30.verticalSpace,
              Image.asset(ImgPath.appLogo),
              Text(
                "Let's Get Started",
                style: Get.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Expanded(child: Image.asset(ImgPath.tow4)),
              AppButton(
                onPressed: () => controller.loginPage(),
                title: controller.login,
                
              ),
              12.verticalSpace,
              AppButton(
                onPressed: () => controller.signUpPage(),
                title: controller.signUp,
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
