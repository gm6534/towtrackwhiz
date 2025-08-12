import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "Towing Hot Zones Map",
            style: Get.textTheme.headlineLarge,
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.grey.shade300,
              image: DecorationImage(image: AssetImage(ImgPath.mapImg), fit: BoxFit.cover)
            ),
            // child: const Center(child: Text("Map Placeholder")),
          ),
        ),
        10.verticalSpace,
      ],
    );
  }
}
