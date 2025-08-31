import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Common/helper.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

class AlertCardWidget extends StatelessWidget {
  final String title;
  final String location;
  final String imgUrl;
  final String time;
  final String upVote;
  final String downVote;
  final Function()? onTapUpVote;
  final Function()? onTapDownVote;

  const AlertCardWidget({
    super.key,
    required this.title,
    required this.location,
    required this.imgUrl,
    required this.time,
    this.upVote = "0",
    this.downVote = "0",
    this.onTapUpVote,
    this.onTapDownVote,
  });

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
                    Strings.emergency,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: AppColors.redColor,
                    ),
                  ),
                ),
                Text(
                  TowEventExtension.fromValue(title)!.label,
                  style: Get.textTheme.labelLarge,
                ),
                Row(
                  spacing: 5.w,
                  children: [
                    Text(location, style: Get.textTheme.bodyMedium),
                    Image.asset(
                      ImgPath.locationIcon,
                      height: 15.w,
                      width: 15.w,
                    ),
                  ],
                ),
                Row(
                  spacing: 10.w,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 3.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: onTapUpVote,
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: AppColors.greenColor,
                            size: 28.w,
                          ),
                        ),
                        Text(
                          upVote,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 3.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: onTapDownVote,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.redColor,
                            size: 28.w,
                          ),
                        ),
                        Text(
                          downVote,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ],
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
                Helper.timeAgo(time),
                style: Get.textTheme.labelLarge?.copyWith(
                  color: AppColors.greyColor.withValues(alpha: 0.9),
                ),
              ),
              if (imgUrl.isNotEmpty)
                Image.network(imgUrl, height: 70.w, width: 70.w)
              else
                Image.asset(ImgPath.tow1Png, height: 70.w, width: 70.w),
            ],
          ),
        ],
      ),
    );
  }
}
