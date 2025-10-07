import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:towtrackwhiz/Controller/Dashboard/home_controller.dart';

import '../../Core/Utils/app_colors.dart';

class HeatmapWidget extends GetView<HomeController> {
  const HeatmapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // assign params after creation

    return Stack(
      children: [
        Obx(
          () => GoogleMap(
            polygons: controller.polygons.value,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                controller.initialLat.value,
                controller.initialLong.value,
              ),
              zoom: 12,
            ),
            onMapCreated: (c) {
              if (!controller.heatMapControllerCompleter.isCompleted) {
                controller.heatMapControllerCompleter.complete(c);
              }
            },
            markers: {
              if (controller.currentMarker.value != null)
                Marker(
                  markerId: const MarkerId("me"),
                  position: controller.currentMarker.value!,
                  infoWindow: const InfoWindow(title: "You"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure,
                  ),
                ),
            },
            compassEnabled: false,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
        ),
        Positioned(
          top: 10.w,
          right: 10.w,
          child: Column(
            children: [
              FloatingActionButton.small(
                heroTag: 'refreshHeatmap',
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                backgroundColor: AppColors.primary,
                onPressed: controller.refreshZones,
                child: const Icon(Icons.refresh, color: AppColors.white),
              ),
              SizedBox(height: 3.w),
              FloatingActionButton.small(
                heroTag: 'legend',
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                backgroundColor: AppColors.primary,
                onPressed: _showLegend,
                child: const Icon(Icons.legend_toggle, color: AppColors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLegend() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Heatmap legend',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.square, color: Colors.green),
                SizedBox(width: 8),
                Text('Green: 1–4 alerts (Safe)'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.square, color: Colors.orange),
                SizedBox(width: 8),
                Text('Yellow: 5–9 alerts (Caution)'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.square, color: Colors.red),
                SizedBox(width: 8),
                Text('Red: 10+ alerts (High risk)'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
