import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';

import '../../Core/Routes/app_route.dart';

class GetStartedScreen extends StatelessWidget {
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
              Text(AppHeadings.letGetStarted, style: Get.textTheme.displaySmall),
              Expanded(child: Image.asset(ImgPath.tow3Png)),
              AppButton(
                onPressed: () {
                  Get.toNamed(AppRoute.loginScreen);
                },
                title: ActionText.signIn,
              ),
              AppButton(
                onPressed: () {
                  Get.toNamed(AppRoute.signUpScreen);
                },
                isOutlined: true,
                title: ActionText.singUp,
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
