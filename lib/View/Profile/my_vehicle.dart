import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Dashboard/profile_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';
import 'package:towtrackwhiz/View/Profile/vehicle_detail_page.dart';

import '../../Core/Common/Widgets/toasts.dart';
import '../../Core/Constants/app_strings.dart';
import '../../Core/Utils/app_colors.dart';
import '../Common/vehicle_card.dart';

class VehicleScreen extends GetView<ProfileController> {
  const VehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.primary),
        backgroundColor: AppColors.scaffoldBgColor,
        surfaceTintColor: AppColors.scaffoldBgColor,
        title: Image.asset(ImgPath.appLogo, width: context.width * 0.5),
      ),
      body: Obx(() {
        if (controller.isVehicleLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.vehiclesList.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10.w,
            children: [
              Text("Registered Vehicles", style: Get.textTheme.headlineMedium),
              10.verticalSpace,
              Expanded(
                child: Center(
                  child: Text(
                    "No record found",
                    style: context.textTheme.titleLarge,
                  ),
                ),
              ),
              AppButton(
                onPressed: () {
                  Get.toNamed(AppRoute.addVehicles);
                },
                title: "Add Vehicle",
              ),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10.w,
          children: [
            Text("Registered Vehicles", style: Get.textTheme.headlineMedium),
            10.verticalSpace,
            Expanded(
              child: ListView.separated(
                itemCount: controller.vehiclesList.length,
                separatorBuilder: (_, __) => 10.verticalSpace,
                itemBuilder: (context, index) {
                  final vehicle = controller.vehiclesList[index];
                  return VehicleCard(
                    name: vehicle.make!,
                    plate: vehicle.licensePlate!,
                    model: vehicle.model!,
                    onDelete: () async {
                      var response = await ToastAndDialog.confirmation(
                        title: "Delete Vehicle",
                        message:
                            "Are you sure you want to delete this vehicle?",
                      );
                      if (response) {
                        controller.deleteVehicle(vId: vehicle.id!);
                      }
                    },
                    onEdit: () {
                      controller.navigateToUpdateVehicle(vehicle);
                    },
                    onTap: () {
                      Get.to(() => VehicleDetailPage(vehicle: vehicle));
                    },
                  );
                },
              ),
            ),
            AppButton(
              onPressed: () {
                Get.toNamed(AppRoute.addVehicles);
              },
              title: "Add Vehicle",
            ),
          ],
        );
      }),
    );
  }
}
