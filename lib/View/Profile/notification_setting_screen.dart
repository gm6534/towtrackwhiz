import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Dashboard/profile_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/common_app_bar.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

class NotificationSettingScreen extends GetView<ProfileController> {
  const NotificationSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: commonAppBar,
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: AppColors.primary),
      //   backgroundColor: AppColors.scaffoldBgColor,
      //   surfaceTintColor: AppColors.scaffoldBgColor,
      //   title: Image.asset(ImgPath.appLogo, width: context.width * 0.5),
      // ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 20.w,
              children: [
                Text(
                  AppHeadings.notificationSetting,
                  style: Get.textTheme.headlineLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Strings.availabilityOfNotification,
                      style: Get.textTheme.titleLarge,
                    ),
                    Obx(() {
                      return Switch(
                        padding: EdgeInsets.zero,
                        activeTrackColor: AppColors.primary,
                        inactiveThumbColor: AppColors.greyColor,
                        inactiveTrackColor: AppColors.greyColor.withValues(
                          alpha: 0.4,
                        ),
                        value: controller.isNotificationEnabled.value,
                        onChanged: (val) {
                          controller.toggleNotify(value: val);
                        },
                      );
                    }),
                  ],
                ),
                // Text("Choose tone", style: Get.textTheme.titleMedium),
                // Container(
                //   width: context.width,
                //   padding: EdgeInsets.symmetric(
                //     horizontal: 12.w,
                //     vertical: 14.h,
                //   ),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10.r),
                //     color: Colors.white,
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.black12,
                //         blurRadius: 4,
                //         offset: Offset(0, 2),
                //       ),
                //     ],
                //   ),
                //   child: Text(
                //     "------------------",
                //     style: Get.textTheme.titleMedium,
                //   ),
                // ),
              ],
            ),
            // AppButton(
            //   onPressed: () {
            //     // controller.saveSettings();
            //   },
            //   title: ActionText.save,
            // ),
          ],
        ),
      ),
    );
  }
}
