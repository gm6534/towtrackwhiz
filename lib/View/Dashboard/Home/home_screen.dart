import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        20.verticalSpace,
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "Towing Hot Zones Map",
            style: Get.textTheme.headlineLarge?.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.grey.shade300,
            ),
            child: const Center(child: Text("Map Placeholder")),
          ),
        ),
      ],
    );
  }
}
