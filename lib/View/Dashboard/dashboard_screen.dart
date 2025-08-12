import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

import '../../Controller/Dashboard/dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BaseScaffold(
        appBar: AppBar(
          leading: SizedBox.shrink(),
          leadingWidth: 0,
          backgroundColor: AppColors.scaffoldBgColor,
          surfaceTintColor: AppColors.scaffoldBgColor,
          title: Image.asset(ImgPath.appLogo, width: context.width * 0.5),
        ),
        body: controller.pages[controller.currentIndex.value],
        floatingActionButton:
            (controller.currentIndex.value == 3)
                ? null
                : FloatingActionButton.extended(
                  backgroundColor: AppColors.primary,
                  icon: Image.asset(
                    ImgPath.announcementIcon,
                    height: 24.w,
                    width: 24.w,
                  ),
                  label: Text(
                    "Report Tow",
                    style: Get.textTheme.headlineSmall?.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  onPressed: controller.showReportTowActivityDialog,
                ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.greyColor,
          backgroundColor: AppColors.white,
          items: [
            BottomNavigationBarItem(
              icon:
                  (controller.currentIndex.value == 0)
                      ? Image.asset(
                        ImgPath.filledHomeIcon,
                        height: 24.w,
                        width: 24.w,
                      )
                      : Image.asset(
                        ImgPath.homeIcon,
                        height: 24.w,
                        width: 24.w,
                      ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon:
                  (controller.currentIndex.value == 1)
                      ? Image.asset(
                        ImgPath.alertIcon,
                        height: 24.w,
                        width: 24.w,
                        color: AppColors.primary,
                      )
                      : Image.asset(
                        ImgPath.outlinedAlertIcon,
                        height: 24.w,
                        width: 24.w,
                      ),
              label: 'Alert',
            ),
            BottomNavigationBarItem(
              icon:
                  (controller.currentIndex.value == 2)
                      ? Image.asset(
                        ImgPath.filledLookupIcon,
                        height: 24.w,
                        width: 24.w,
                      )
                      : Image.asset(
                        ImgPath.lookupIcon,
                        height: 24.w,
                        width: 24.w,
                      ),
              label: 'Look Up',
            ),
            BottomNavigationBarItem(
              icon:
                  (controller.currentIndex.value == 3)
                      ? Image.asset(
                        ImgPath.filledProfileIcon,
                        height: 24.w,
                        width: 24.w,
                      )
                      : Image.asset(
                        ImgPath.profileIcon,
                        height: 24.w,
                        width: 24.w,
                      ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
