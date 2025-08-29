import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';

class VehicleCard extends StatelessWidget {
  final String title;
  final String licensePlate;
  final String model;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const VehicleCard({
    super.key,
    required this.title,
    required this.licensePlate,
    required this.model,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${Strings.licensePlate}: $licensePlate",
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "${Strings.model}:$model",
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Action buttons
            Column(
              children: [
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(Icons.delete, color: Colors.red, size: 18.sp),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: onEdit,
                  child: Icon(Icons.edit, color: Colors.cyan, size: 18.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
