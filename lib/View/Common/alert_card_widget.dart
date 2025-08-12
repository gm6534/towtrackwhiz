import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

class AlertCardWidget extends StatelessWidget {
  const AlertCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      margin: EdgeInsets.symmetric(vertical: 3.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.w,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.lightRed,
            child: Center(
              child: Image.asset(ImgPath.alertIcon, height: 20.w, width: 20.w),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5.w,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 5.w,
                    horizontal: 10.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightRed,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    "Emergency",
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: AppColors.redColor,
                    ),
                  ),
                ),
                Text("Gas Leak Reported", style: Get.textTheme.labelLarge),
                Row(
                  spacing: 5.w,
                  children: [
                    Text("Location", style: Get.textTheme.bodyMedium),
                    Image.asset(
                      ImgPath.locationIcon,
                      height: 15.w,
                      width: 15.w,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            spacing: 10.w,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "20min Ago",
                style: Get.textTheme.labelLarge?.copyWith(
                  color: AppColors.greyColor.withValues(alpha: 0.9),
                ),
              ),
              Image.asset(ImgPath.tow1Png, height: 70.w, width: 70.w),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPoint(String point) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 16.sp, color: Colors.red)),
          Expanded(
            child: Text(
              point,
              style: TextStyle(fontSize: 14.sp, color: Colors.red[900]),
            ),
          ),
        ],
      ),
    );
  }
}
