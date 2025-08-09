import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

import '../../Controller/Other/initial_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';

class SplashScreen extends GetView<InitialController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 20.w,
            children: [
              SvgPicture.asset(ImgPath.appLogoSvg, height: 100.w),
              // Icon(Icons.cleaning_services, size: 100.w, color: Colors.white),
              Text(
                controller.appName,
                style: Get.textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
