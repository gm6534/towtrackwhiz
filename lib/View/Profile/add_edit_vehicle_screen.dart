import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Dashboard/profile_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_heading_text_field.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/common_app_bar.dart';
import 'package:towtrackwhiz/Core/Common/validation_helper.dart';
import 'package:towtrackwhiz/Model/Vehicle/vehicle_list_model.dart';

import '../../Core/Constants/app_strings.dart';
import '../../Core/Utils/app_colors.dart';

class AddEditVehicleScreen extends GetView<ProfileController> {
  AddEditVehicleScreen({super.key});

  final VehiclesListModel? argument = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: commonAppBar,
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: AppColors.primary),
      //   backgroundColor: AppColors.scaffoldBgColor,
      //   surfaceTintColor: AppColors.scaffoldBgColor,
      //   title: Image.asset(ImgPath.appLogo, width: context.width * 0.5),
      // ),
      body: Form(
        key: controller.addVehicleFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10.w,
            children: [
              Text(
                argument != null
                    ? AppHeadings.updateVehicle
                    : AppHeadings.addVehicles,
                style: Get.textTheme.headlineMedium,
              ),
              10.verticalSpace,
              AppHeadingTextField(
                controller: controller.licPlateController,
                heading: Strings.licensePlate,
                hintText: "",
                textInputType: TextInputType.text,
                onChanged: (value) {
                  controller.licPlateController.text = value.toUpperCase();
                },
                validator:
                    (value) => ValidationHelper.validateNonEmpty(
                      value,
                      "License Plate",
                    ),
              ),
              AppHeadingTextField(
                controller: controller.makeController,
                heading: AppHeadings.make,
                textInputType: TextInputType.name,
                hintText: "",
                validator:
                    (value) => ValidationHelper.validateNonEmpty(value, "Make"),
              ),
              AppHeadingTextField(
                controller: controller.modelController,
                heading: AppHeadings.vehicleModel,
                hintText: "",
                textInputType: TextInputType.name,
                validator:
                    (value) => ValidationHelper.validateNonEmpty(
                      value,
                      "Vehicle Model",
                    ),
              ),
              AppHeadingTextField(
                controller: controller.modelYearController,
                heading: AppHeadings.modelYear,
                textInputType: TextInputType.number,
                hintText: "",
                readOnly: true,
                onTap: () => controller.showYearPicker(context),
                validator:
                    (value) => ValidationHelper.validateNonEmpty(
                      value,
                      "Vehicle year",
                    ),
              ),
              AppHeadingTextField(
                controller: controller.colorController,
                heading: AppHeadings.vehicleColor,
                hintText: "",
                textInputType: TextInputType.name,
                readOnly: true,
                onTap: () => controller.pickColor(context),
                validator:
                    (value) => ValidationHelper.validateNonEmpty(
                      value,
                      "Vehicle Color",
                    ),
              ),
              AppHeadingTextField(
                controller: controller.registerStateController,
                heading: AppHeadings.registrationState,
                textInputType: TextInputType.name,
                hintText: "",
                validator:
                    (value) => ValidationHelper.validateNonEmpty(
                      value,
                      "Registration State",
                    ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
        child: AppButton(
          onPressed: () {
            if (argument != null) {
              controller.updateVehicle(vid: argument!.id!);
            } else {
              controller.addVehicle();
            }
          },
          title: argument != null ? ActionText.update : ActionText.save,
        ),
      ),
    );
  }
}
