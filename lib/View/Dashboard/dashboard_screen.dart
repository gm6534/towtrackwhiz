import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/common_app_bar.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

import '../../Controller/Dashboard/dashboard_controller.dart';
import '../../Core/Common/Widgets/toasts.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        bool result = await ToastAndDialog.confirmation(
          title: ToastMsg.closeApp,
          message: ToastMsg.closeAppConfirmation,
        );
        if (result) {
          exit(0);
        }
      },
      child: Obx(
        () => BaseScaffold(
          // appBar: commonAppBar,
          body:
              controller.isDashboardLoading.value
                  ? Center(child: CircularProgressIndicator())
                  // : IndexedStack(
                  //   index: controller.currentIndex.value,
                  //   children: controller.pages,
                  // ),
                  : controller.pages[controller.currentIndex.value],
          floatingActionButton:
              controller.isDashboardLoading.value
                  ? null
                  : ((controller.currentIndex.value == 0)
                      ? FloatingActionButton.extended(
                        backgroundColor: AppColors.primary,
                        icon: Image.asset(
                          ImgPath.announcementIcon,
                          height: 24.w,
                          width: 24.w,
                        ),
                        label: Text(
                          Strings.reportTow,
                          style: Get.textTheme.headlineSmall?.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        onPressed: controller.showReportTowActivityDialog,
                      )
                      : null),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar:
              controller.isDashboardLoading.value
                  ? null
                  : BottomNavigationBar(
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
                        label: AppHeadings.home,
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
                        label: AppHeadings.alert,
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
                        label: AppHeadings.lookUp,
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
                        label: AppHeadings.profile,
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
