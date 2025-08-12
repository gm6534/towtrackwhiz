import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Dashboard/profile_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_heading_text_field.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';

import '../../Core/Constants/app_strings.dart';
import '../../Core/Utils/app_colors.dart';

class AddVehicleScreen extends GetView<ProfileController> {
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.primary),
        backgroundColor: AppColors.scaffoldBgColor,
        surfaceTintColor: AppColors.scaffoldBgColor,
        title: Image.asset(ImgPath.appLogo, width: context.width * 0.5),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10.w,
        children: [
          Text("Add Vehicles", style: Get.textTheme.headlineMedium),
          10.verticalSpace,
          AppHeadingTextField(heading: "License Plate", hintText: "LUE6850"),
          AppHeadingTextField(heading: "Make", hintText: "-----------"),
          Spacer(),
          AppButton(
            onPressed: () {
              // handle add vehicle
            },
            title: ActionText.save,
          ),
          20.verticalSpace,
        ],
      ),
    );
  }
}
