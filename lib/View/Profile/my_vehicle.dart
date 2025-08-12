import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:towtrackwhiz/View/Common/vehicle_card_widget.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';

class VehicleScreen extends StatelessWidget {
  const VehicleScreen({super.key});

  final List<Map<String, String>> vehicles = const [
    {"title": "Car 02465", "plate": "Lue4567", "model": "2022"},
    {"title": "Car 02465", "plate": "Lue4567", "model": "2022"},
    {"title": "Car 02465", "plate": "Lue4567", "model": "2022"},
    {"title": "Car 02465", "plate": "Lue4567", "model": "2022"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),

              // Page title
              Text(
                "My vehicle",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8.h),

              // Logo + title
              Row(
                children: [
                  Icon(Icons.cloud, color: Colors.cyan, size: 20.sp),
                  SizedBox(width: 4.w),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "TowTrack",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: "Whiz",
                          style: TextStyle(
                            color: Colors.cyan,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Section title
              Text(
                "Registered Vehicles",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),

              // Vehicle list
              Expanded(
                child: ListView.separated(
                  itemCount: vehicles.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    final v = vehicles[index];
                    return VehicleCard(
                      title: v['title']!,
                      licensePlate: v['plate']!,
                      model: v['model']!,
                      onDelete: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Deleted ${v['title']}')),
                        );
                      },
                      onEdit: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Edit ${v['title']}')),
                        );
                      },
                    );
                  },
                ),
              ),

              // Add Vehicle button
              SizedBox(
                width: double.infinity,
                height: 44.h,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(AppRoute.addVehicles),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  child: Text(
                    "Add Vehicle",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
