import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../Core/Constants/app_strings.dart';
import '../../Core/Utils/app_colors.dart';

class VehicleCard extends StatelessWidget {
  final String name;
  final String plate;
  final String model;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const VehicleCard({
    super.key,
    required this.name,
    required this.plate,
    required this.model,
    required this.onDelete,
    required this.onEdit, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          spacing: 15.w,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5.w,
                children: [
                  Text(name, style: Get.textTheme.titleLarge),
                  Text(
                    "${Strings.licensePlate}: $plate",
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: AppColors.greyColor,
                    ),
                  ),
                  Text(
                    "${Strings.model}: $model",
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: AppColors.greyColor,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              child: Image.asset(
                ImgPath.deleteIcon,
                color: AppColors.redColor,
                height: 20.w,
                width: 20.w,
              ),
            ),
            GestureDetector(
              onTap: onEdit,
              child: Image.asset(
                ImgPath.editIcon,
                color: AppColors.primary,
                height: 20.w,
                width: 20.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
