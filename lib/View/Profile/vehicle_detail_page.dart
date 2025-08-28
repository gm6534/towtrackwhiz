import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Dashboard/profile_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/toasts.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

import '../../Model/Vehicle/vehicle_list_model.dart';

class VehicleDetailPage extends GetView<ProfileController> {
  final VehiclesListModel vehicle;

  const VehicleDetailPage({super.key, required this.vehicle});

  Widget _buildInfoTile(String title, String? value) {
    return value != null
        ? Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title: ",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              Expanded(child: Text(value, style: TextStyle(fontSize: 14.sp))),
            ],
          ),
        )
        : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.primary,
        surfaceTintColor: AppColors.scaffoldBgColor,
        title: Text(
          "Vehicle Detail",
          style: context.textTheme.headlineMedium?.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoTile("License Plate", vehicle.licensePlate),
            _buildInfoTile("Make", vehicle.make),
            _buildInfoTile("Model", vehicle.model),
            _buildInfoTile("Color", vehicle.color),
            _buildInfoTile("Registration State", vehicle.registrationState),
            _buildInfoTile("Created At", vehicle.createdAt),
            _buildInfoTile("Status", vehicle.status),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1),
          ],
        ),
        child: Row(
          spacing: 10.w,
          children: [
            Expanded(
              child: AppButton(
                onPressed: () {
                  Get.back();
                  controller.navigateToUpdateVehicle(vehicle);
                },
                title: ActionText.edit,
              ),
            ),
            Expanded(
              child: AppButton(
                onPressed: () async {
                  var response = await ToastAndDialog.confirmation(
                    title: "Delete Vehicle",
                    message: "Are you sure you want to delete this vehicle?",
                  );
                  if (response) {
                    Get.back();
                    controller.deleteVehicle(vId: vehicle.id!);
                  }
                },
                btnColor: AppColors.redColor,
                title: ActionText.delete,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
