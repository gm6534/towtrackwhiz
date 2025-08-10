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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 20.w,
            children: [
              Image.asset(controller.appLogo, width: 270.w,),
              // Icon(Icons.fire_truck, size: 70.w, color: AppColors.primary),
              // Text(
              //   controller.appName,
              //   style: Get.textTheme.displayMedium?.copyWith(
              //     color: AppColors.primary,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
