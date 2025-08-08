import 'dart:io';

import 'package:towtrackwhiz/Controller/dashboard_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_drawer.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../Core/Common/Widgets/toasts.dart';
import '../../Core/Constants/app_strings.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        bool result = await ToastAndDialog.confirmation(
          title: "Close App",
          message: ToastMsg.closeAppConfirmation,
        );
        if (result) {
          exit(0);
        }
      },
      child: BaseScaffold(
        appBarTitle: "dashboard".tr,
        drawer: AppDrawer(),
        body: Obx(() {
          if (controller.isDashboardLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(children: []);
        }),
      ),
    );
  }

  Widget filterBar() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.w),
      child: Row(
        children:
            TaskFilter.values.map((filter) {
              final isSelected = controller.selectedFilter.value == filter;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: GestureDetector(
                    onTap: () {
                      controller.selectedFilter.value = filter;
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppColors.primary
                                : AppColors.secondary.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text(
                          filterLabel(filter),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
