import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:towtrackwhiz/Controller/Dashboard/home_controller.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';

class HomeScreen extends GetView<HomeController> {
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
            AppHeadings.towingHotZonesMap,
            style: Get.textTheme.headlineLarge,
          ),
        ),
        Expanded(
          child: Container(
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
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    controller.initialLat.value,
                    controller.initialLong.value,
                  ),
                  zoom: 11.0,
                ),
                liteModeEnabled: true,
                onMapCreated: (GoogleMapController value) {
                  if (!controller.mapController.isCompleted) {
                    controller.mapController.complete(value);
                  }
                },
                mapToolbarEnabled: true,
                markers: {
                  Marker(
                    markerId: const MarkerId('currentLocation'),
                    position: LatLng(
                      controller.initialLat.value,
                      controller.initialLong.value,
                    ),
                    // icon: AssetMapBitmap(ImgPath.carIcon, height: 20.w, width: 40.w),
                    infoWindow: InfoWindow(
                      title: AppHeadings.location,
                      snippet:
                          '${controller.initialLat.value}, ${controller.initialLong.value}',
                    ),
                  ),
                },
              ),
            ),
          ),
        ),
        30.verticalSpace,
      ],
    );
  }
}
