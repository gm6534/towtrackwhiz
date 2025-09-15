import 'package:flutter/material.dart';

import '../../../core/Constants/app_strings.dart';
import '../../../core/Utils/app_colors.dart';

AppBar? get commonAppBar {
  return AppBar(
    // leading: SizedBox.shrink(),
    // leadingWidth: 0,
    iconTheme: IconThemeData(color: AppColors.primary),
    backgroundColor: AppColors.scaffoldBgColor,
    surfaceTintColor: AppColors.scaffoldBgColor,
    title: Image.asset(
      ImgPath.appLogo,
      // width: Get.width * 0.5,
      fit: BoxFit.fitHeight,
      height: kToolbarHeight,
    ),
  );
}
