import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Dashboard/home_controller.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';

import '../../../Core/Common/Widgets/app_button.dart';
import '../../../Core/Common/permission_manager.dart';
import '../../../Core/Utils/app_colors.dart';
import '../../Common/heat_zone_class.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.verticalSpace,
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            AppHeadings.towingHotZonesMap,
            style: Get.textTheme.headlineLarge,
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isHeatMapLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (!controller.isLocServiceEnabled.value ||
                !controller.isLocPermissionGranted.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 40.w,
                  children: [
                    Text(
                      !controller.isLocServiceEnabled.value
                          ? "Location Service Disabled! Please click to enable location services"
                          : "Location Permission Denied! Please click to allow location access",
                      textAlign: TextAlign.center,
                      style: Get.textTheme.bodyMedium,
                    ),
                    AppButton(
                      isOutlined: true,
                      width: context.width * 0.3,
                      btnColor: AppColors.primary,
                      onPressed: () async {
                        bool isPermissionGranted = await PermissionManager.requestNeedyPermissions();
                        if (isPermissionGranted) {
                          controller.refreshZones();
                        }
                      },
                      title:
                          !controller.isLocServiceEnabled.value
                              ? "Enable"
                              : "Allow",
                    ),
                  ],
                ),
              );
            }
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Colors.grey.shade300,
                // image: DecorationImage(
                //   image: AssetImage(ImgPath.mapImg),
                //   fit: BoxFit.cover,
                // ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: HeatmapWidget(),
              ),
            );
          }),
        ),
        // 30.verticalSpace,
      ],
    );
  }
}
