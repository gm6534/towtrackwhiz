import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:towtrackwhiz/Controller/Dashboard/dashboard_controller.dart';

class HomeScreen extends GetView<DashboardController> {
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
            "Towing Hot Zones Map",
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
                  target: LatLng(52.577622, -2.135586),
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
                    position: LatLng(52.577622, -2.135586),
                    // icon: AssetMapBitmap(ImgPath.carIcon, height: 20.w, width: 40.w),
                    infoWindow: InfoWindow(
                      title: 'Location',
                      snippet: '${52.577622}, ${-2.135586}',
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
