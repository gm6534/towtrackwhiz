import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Dashboard/dashboard_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_heading_text_field.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

class ReportTowActivityDialog extends GetView<DashboardController> {
  const ReportTowActivityDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal:20.w),
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15.w,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 10.w,
                children: [
                  Text(
                    "Report Tow Activity",
                    style: Get.textTheme.headlineMedium,
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.cancel, color: Colors.red, size: 28.sp),
                  ),
                ],
              ),
              Obx(() {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10.w,
                  children: [
                    Text("Type", style: Get.textTheme.titleLarge),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBgColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: AppColors.white,
                          hint: Text(
                            "Select Type....",
                            style: Get.textTheme.bodySmall,
                          ),
                          isExpanded: true,
                          value: controller.selectedType.value,
                          icon: Transform.rotate(
                            angle: -math.pi / 2,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.primary,
                              size: 18.w,
                            ),
                          ),
                          items:
                              controller.towTypes.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                          onChanged: (value) {
                            controller.selectedType.value = value ?? "";
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10.w,
                children: [
                  Text("Location", style: Get.textTheme.titleLarge),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Choose on map",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Icon(Icons.location_on, color: Colors.red),
                      ],
                    ),
                  ),
                ],
              ),
              AppHeadingTextField(
                controller: controller.commentController,
                heading: "Comments (Optional)",
                hintText: "Type Comment",
                fillColor: AppColors.scaffoldBgColor,
                textInputAction: TextInputAction.newline,
                textInputType: TextInputType.multiline,
                maxLines: 4,
                inputFormatters: [LengthLimitingTextInputFormatter(100)],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10.w,
                children: [
                  Text(
                    "Upload Image (Optional)",
                    style: Get.textTheme.titleLarge,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Attach file",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Icon(Icons.attach_file, color: Colors.cyan),
                      ],
                    ),
                  ),
                ],
              ),
              AppButton(
                onPressed: () {
                  Get.back();
                },
                title: "Submit Report",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
