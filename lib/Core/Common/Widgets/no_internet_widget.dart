import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20.w,
        children: [
          SizedBox(
            height: 16.w,
            width: 16.w,
            child: CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: Colors.red,
              strokeWidth: 2.5,
            ),
          ),
          Text(
            ToastMsg.noInternetConnection,
            style: Get.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
