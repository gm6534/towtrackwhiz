import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

import '../../../Controller/Dashboard/lookup_controller.dart';

class LookupScreen extends GetView<LookupController> {
  const LookupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.w,
      children: [
        Text(
          "Who Towed My Car?",
          style: Get.textTheme.headlineLarge?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        10.verticalSpace,
        Container(
          margin: EdgeInsets.all(5.w),
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
              color: AppColors.greyColor.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            spacing: 3.w,
            children: [
              Center(
                child: Text(
                  "Before You Start",
                  style: Get.textTheme.headlineSmall,
                ),
              ),
              Text(
                AppHeadings.beforeStart,
                textAlign: TextAlign.center,
                style: Get.textTheme.titleSmall?.copyWith(
                  color: AppColors.greyColor.withValues(alpha: 0.9),
                ),
              ),
              10.verticalSpace,
              buildTextParagraphWidget("Vehicle Identification Number (VIN)"),
              buildTextParagraphWidget("License plate number"),
              buildTextParagraphWidget("Vehicle make and model"),
              buildTextParagraphWidget("Year of manufacture"),
              buildTextParagraphWidget("City of towing"),
            ],
          ),
        ),
        20.verticalSpace,
        Row(
          children: [
            Icon(Icons.location_on, color: AppColors.primary),
            Text(
              'Select Your City',
              style: Get.textTheme.headlineSmall?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        5.verticalSpace,

        DropdownButtonFormField<String>(
          dropdownColor: AppColors.white,
          items:
              controller.cities
                  .map(
                    (city) => DropdownMenuItem(
                      value: city,
                      child: Text(city, style: Get.textTheme.titleSmall),
                    ),
                  )
                  .toList(),
          onChanged: (value) {},
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12.w),
            hintText: "Choose Your City",
            hintStyle: Get.textTheme.titleSmall?.copyWith(
              color: AppColors.greyColor,
            ),
            filled: true,
            fillColor: AppColors.white,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          icon: Transform.rotate(
            angle: -math.pi / 2, // points down
            child: Icon(Icons.arrow_back_ios, color: Colors.cyan, size: 18.w),
          ),
          isExpanded: true,
        ),
      ],
    );
  }

  buildTextParagraphWidget(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 15.w,
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            color: AppColors.black,
            shape: BoxShape.circle,
          ),
        ),
        Text(text, style: Get.textTheme.titleMedium),
      ],
    );
  }
}
