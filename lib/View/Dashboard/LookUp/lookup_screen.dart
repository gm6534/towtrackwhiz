import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';
import 'package:towtrackwhiz/Model/lookup_res_model.dart';

import '../../../Controller/Dashboard/lookup_controller.dart';
import '../../../Core/Common/Widgets/app_web_view.dart';

class LookupScreen extends StatelessWidget {
  const LookupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LookupController>(
      init: LookupController(),
      builder: (controller) {
        return RefreshIndicator(
          backgroundColor: AppColors.scaffoldBgColor,
          color: AppColors.primary,
          onRefresh: controller.getLookupData,
          child: Obx(() {
            if (controller.isLookupLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.lookupList.isEmpty) {
              return Center(
                child: Text(
                  Strings.noRecordFound,
                  style: context.textTheme.titleMedium,
                ),
              );
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15.w,
                children: [
                  5.verticalSpace,
                  Text(
                    "Who Towed My Car?",
                    style: Get.textTheme.headlineLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.greyColor),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      spacing: 10.w,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.15,
                          ),
                          radius: 25.w,
                          child: Icon(
                            Icons.open_in_new,
                            color: AppColors.primary,
                            size: 30.w,
                          ),
                        ),
                        Text(
                          'Search Official Towed Car Database',
                          style: Get.textTheme.headlineSmall?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Select your city to be redirected to the official towing website',
                          textAlign: TextAlign.center,
                          style: Get.textTheme.bodySmall?.copyWith(
                            color: AppColors.greyColor,
                          ),
                        ),
                        Text(
                          'Select Your City',
                          textAlign: TextAlign.center,
                          style: Get.textTheme.titleMedium,
                        ),

                        DropdownButtonFormField<LookupResModel>(
                          dropdownColor: AppColors.white,
                          value: controller.selectedCity.value,
                          items:
                              controller.lookupList.map((city) {
                                return DropdownMenuItem(
                                  value: city,
                                  child: Text(
                                    "${city.cityName} ${city.cityCode != null && city.cityCode!.isNotEmpty ? "(${city.cityCode})" : ""}",
                                    style: Get.textTheme.titleSmall,
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            controller.selectedCity.value = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(12.w),
                            filled: true,
                            fillColor: AppColors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.greyColor,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.greyColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.greyColor,
                              ),
                            ),
                          ),
                          icon: Transform.rotate(
                            angle: -math.pi / 2,
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.cyan,
                              size: 18.w,
                            ),
                          ),
                          isExpanded: true,
                        ),
                      ],
                    ),
                  ),

                  if (controller.selectedCity.value != null &&
                      controller.selectedCity.value?.cityName !=
                          Strings.chooseYourCity) ...[
                    Container(
                      // margin: EdgeInsets.all(5.w),
                      padding: EdgeInsets.all(15.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(
                          color: AppColors.greyColor.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8.w,
                        children: [
                          Text(
                            "Have this information ready:",
                            style: Get.textTheme.titleLarge,
                          ),
                          // Text(
                          //   AppHeadings.beforeStart,
                          //   textAlign: TextAlign.center,
                          //   style: Get.textTheme.titleSmall?.copyWith(
                          //     color: AppColors.greyColor.withValues(alpha: 0.9),
                          //   ),
                          // ),
                          // 10.verticalSpace,
                          buildTextParagraphWidget(
                            "License plate number (most reliable)",
                          ),
                          buildTextParagraphWidget(
                            "Vehicle Identification Number (VIN)",
                          ),
                          buildTextParagraphWidget(
                            "Vehicle Year, Make and Model",
                          ),
                          buildTextParagraphWidget(
                            "Location where vehicle was towed from",
                          ),
                          buildTextParagraphWidget("Approximate tow date"),

                          10.verticalSpace,

                          /// --- Button from API ---
                          AppButton(
                            title:
                                "⎋ ${controller.selectedCity.value!.buttonText ?? "Open Site"}",
                            onPressed: () {
                              final city = controller.selectedCity.value!;
                              Get.to(
                                () => AppWebView(
                                  fileUrl: city.lookupUrl ?? "",
                                  barTitle: city.cityName ?? "",
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    NotesCard(
                      title: "Important Notes",
                      tips: [
                        "Allow 2 hours from tow time for records to appear in the system",
                        "Vehicles that have been released are not searchable",
                        "At least one search parameter is required",
                      ],
                    ),

                    TipsCard(
                      title: "Other Quick Ways to Find Your Car",
                      description:
                          "Don't want to go through the site? Try this instead:",
                      tips: controller.selectedCity.value?.tips ?? [],
                    ),
                    10.verticalSpace,
                  ],
                ],
              ),
            );
          }),
        );
      },
    );
  }

  buildTextParagraphWidget(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10.w,
      children: [
        Image.asset(ImgPath.circleTick, width: 20.w, height: 20.w),
        Expanded(child: Text(text, style: Get.textTheme.labelMedium)),
      ],
    );
  }
}

class TipsCard extends StatelessWidget {
  final String title;
  final String description;
  final List<String> tips;

  const TipsCard({
    super.key,
    required this.title,
    required this.description,
    required this.tips,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: AppColors.greenColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greenColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.w,
        children: [
          /// Title Row
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: AppColors.greenColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Icon(
              Icons.phone_in_talk,
              color: AppColors.greenColor,
              size: 20.w,
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5.w,
              children: [
                Text(
                  title,
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.greenColor,
                  ),
                ),

                /// Description
                Text(
                  description,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: AppColors.greyColor,
                  ),
                ),

                /// Tips List
                ...tips.map(
                  (tip) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8.w,
                    children: [
                      Icon(
                        Icons.play_arrow,
                        color: AppColors.greenColor,
                        size: 18.w,
                      ),

                      Expanded(
                        child: Text(
                          tip,
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: AppColors.greenColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotesCard extends StatelessWidget {
  final String title;
  final List<String> tips;

  const NotesCard({super.key, required this.title, required this.tips});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: AppColors.warningColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.warningColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.w,
        children: [
          /// Title Row
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: AppColors.warningColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: AppColors.warningColor,
              size: 20.w,
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5.w,
              children: [
                Text(
                  title,
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.warningColor,
                  ),
                ),

                /// Tips List
                ...tips.map(
                  (tip) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8.w,
                    children: [
                      Container(
                        height: 5.w,
                        width: 5.w,
                        margin: EdgeInsets.only(top: 8.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.warningColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          tip,
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: AppColors.warningColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
