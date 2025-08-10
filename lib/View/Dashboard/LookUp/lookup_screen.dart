import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Other/Dashboard/lookup_controller.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

class LookupScreen extends GetView<LookupController> {
  const LookupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Who Towed My Car?",
            style: Get.textTheme.headlineLarge?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          20.verticalSpace,
          Center(
            child: Text(
              "Before You Start",
              style: Get.textTheme.headlineSmall?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            AppHeadings.beforeStart,
            style: Get.textTheme.labelLarge?.copyWith(color: Colors.black),
          ),
          10.verticalSpace,

          const Text("- Vehicle Identification Number (VIN)"),
          const Text("- License plate number"),
          const Text("- Vehicle make and model"),
          const Text("- Year of manufacture"),
          const Text("- City of towing"),
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
          20.verticalSpace,

          DropdownButtonFormField(
            items:
                ["Houston (HTX)", "Dallas (DTX)", "Austin (ATX)"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (value) {},
            decoration: const InputDecoration(labelText: "Choose Your City"),
          ),
        ],
      ),
    );
  }
}
