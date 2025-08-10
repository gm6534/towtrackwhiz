import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

import '../../Controller/Other/initial_controller.dart';

class SplashScreen extends GetView<InitialController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 45.w),
            child: Image.asset(controller.appLogo, height: 100.w),
          ),
        ),
      ),
    );
  }
}
