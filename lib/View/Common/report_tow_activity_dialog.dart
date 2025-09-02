import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:towtrackwhiz/Controller/Dashboard/home_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_heading_text_field.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

import '../../Model/Vehicle/vehicle_list_model.dart';

class ReportTowActivityDialog extends GetView<HomeController> {
  const ReportTowActivityDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
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
                    AppHeadings.reportTowActivity,
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
                    Text(AppHeadings.type, style: Get.textTheme.titleLarge),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBgColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border:
                            controller.isTypeValid.value
                                ? null
                                : Border.all(
                                  width: 1.5,
                                  color: AppColors.redColor,
                                ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<TowEvent>(
                          dropdownColor: AppColors.white,
                          hint: Text(
                            Strings.selectType,
                            style: Get.textTheme.bodySmall,
                          ),
                          isExpanded: true,
                          value: controller.selectedType.value,
                          // now TowEvent?
                          icon: Transform.rotate(
                            angle: -math.pi / 2,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.primary,
                              size: 18.w,
                            ),
                          ),
                          items:
                              TowEvent.values.map((event) {
                                return DropdownMenuItem(
                                  value: event,
                                  child: Text(event.label), // show label
                                );
                              }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedType.value =
                                  value; // store enum
                            }
                            controller.isTypeValid.value = true;
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }),
              Obx(() {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10.w,
                  children: [
                    Text("Vehicle", style: Get.textTheme.titleLarge),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldBgColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border:
                            controller.isVehicleSelected.value
                                ? null
                                : Border.all(
                                  width: 1.5,
                                  color: AppColors.redColor,
                                ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<VehiclesListModel>(
                          dropdownColor: AppColors.white,
                          hint: Text(
                            Strings.selectType,
                            style: Get.textTheme.bodySmall,
                          ),
                          isExpanded: true,
                          value: controller.selectedVehicle.value,
                          icon: Transform.rotate(
                            angle: -math.pi / 2,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.primary,
                              size: 18.w,
                            ),
                          ),
                          items:
                              controller.vehiclesList.map((vehicle) {
                                return DropdownMenuItem<VehiclesListModel>(
                                  value: vehicle,
                                  child: Text(
                                    vehicle.licensePlate ?? "Unknown",
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedVehicle.value = value;
                            }
                            controller.isVehicleSelected.value = true;
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }),
              Obx(() {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10.w,
                  children: [
                    Text(AppHeadings.location, style: Get.textTheme.titleLarge),
                    GestureDetector(
                      onTap: () {
                        controller.navigateToPickLoc();
                        controller.isLocationPicked.value = true;
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8.r),
                          border:
                              controller.isLocationPicked.value
                                  ? null
                                  : Border.all(
                                    width: 1.5,
                                    color: AppColors.redColor,
                                  ),
                        ),
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  controller.pickedLocation.value?.latitude !=
                                          null
                                      ? "${controller.pickedLocation.value?.latitude.toStringAsFixed(3)}, ${controller.pickedLocation.value?.longitude.toStringAsFixed(3)}"
                                      : Strings.chooseOnMap,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Icon(Icons.location_on, color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              AppHeadingTextField(
                controller: controller.commentController,
                heading: AppHeadings.comments,
                hintText: Strings.typeComment,
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
                    AppHeadings.uploadImage,
                    style: Get.textTheme.titleLarge,
                  ),
                  GestureDetector(
                    onTap: () => _showAvatarPicker(context),
                    child: Container(
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
                          Expanded(
                            child: Obx(() {
                              return Text(
                                controller.imagePath.value,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: AppColors.greyColor,
                                ),
                              );
                            }),
                          ),
                          Icon(Icons.attach_file, color: Colors.cyan),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              AppButton(
                onPressed: controller.reportTow,
                title: ActionText.submitReport,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAvatarPicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(Strings.chooseImg, style: TextStyle(fontSize: 16.sp)),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text(Strings.camera),
              onTap: () {
                Get.back();
                controller.pickImageFromSource(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text(Strings.gallery),
              onTap: () {
                Get.back();
                controller.pickImageFromSource(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
