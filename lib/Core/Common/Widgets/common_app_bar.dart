import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/Constants/app_strings.dart';
import '../../../core/Utils/app_colors.dart';

AppBar? get commonAppBar {
  return AppBar(
    // leading: SizedBox.shrink(),
    // leadingWidth: 0,
    centerTitle: false,
    iconTheme: IconThemeData(color: AppColors.primary),
    backgroundColor: AppColors.scaffoldBgColor,
    surfaceTintColor: AppColors.scaffoldBgColor,
    title: Image.asset(
      ImgPath.appLogo1,
      // width: Get.width * 0.5,
      fit: BoxFit.fitHeight,
      height: 40.w,
    ),
  );
}
