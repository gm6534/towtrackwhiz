import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:towtrackwhiz/Controller/Dashboard/home_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

class MapPickerScreen extends GetView<HomeController> {
  final CameraPosition? initialCameraPos;

  const MapPickerScreen({this.initialCameraPos, super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(title: const Text("Pick Location")),
      body: Obx(() {
        if (controller.isGetLocLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  initialCameraPos ??
                  CameraPosition(target: LatLng(31.5204, 74.3587), zoom: 12),
              onMapCreated: (mapCtrl) {
                if (!controller.mapController1.isCompleted) {
                  controller.mapController1.complete(mapCtrl);
                }
                if (initialCameraPos != null) {
                  mapCtrl.animateCamera(
                    CameraUpdate.newCameraPosition(initialCameraPos!),
                  );
                }
              },
              markers: {
                if (controller.tempLocation.value != null)
                  Marker(
                    markerId: const MarkerId("preview"),
                    position: controller.tempLocation.value!,
                  ),
                if (controller.pickedLocation.value != null)
                  Marker(
                    markerId: const MarkerId("picked"),
                    position: controller.pickedLocation.value!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueOrange,
                    ),
                  ),
              },
              onTap: (latLng) => controller.previewMarker(latLng),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),

            /// Bottom Button
            if (controller.tempLocation.value != null)
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBgColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10.w,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Location: ",
                              style: context.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: controller.showPickedAddressOnMap.value,
                              style: context.textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      10.verticalSpace,
                      AppButton(
                        onPressed: () async {
                          await controller.setMarker();
                          Get.back(); // Close map and save marker
                        },
                        title: "Set Location",
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}

// class MapPickerScreen extends GetView<HomeController> {
//   final CameraPosition? initialCameraPos;
//
//   const MapPickerScreen({this.initialCameraPos, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(
//       appBar: AppBar(title: const Text("Pick Location")),
//       body: Obx(() {
//         if (controller.isGetLocLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }
//         return GoogleMap(
//           initialCameraPosition:
//               initialCameraPos ??
//               const CameraPosition(target: LatLng(31.5204, 74.3587), zoom: 12),
//           onMapCreated: (mapCtrl) {
//             if (!controller.mapController1.isCompleted) {
//               controller.mapController1.complete(mapCtrl);
//             }
//             mapCtrl.animateCamera(
//               CameraUpdate.newCameraPosition(initialCameraPos!),
//             );
//           },
//           markers:
//               controller.pickedLocation.value != null
//                   ? {
//                     Marker(
//                       markerId: const MarkerId("picked"),
//                       position: controller.pickedLocation.value!,
//                     ),
//                   }
//                   : {},
//           onTap: (latLng) => controller.setMarker(latLng),
//           myLocationEnabled: true,
//           myLocationButtonEnabled: true,
//           // mapToolbarEnabled: ,
//         );
//       }),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () => controller.goToCurrentLocation(),
//       //   child: const Icon(Icons.my_location),
//       // ),
//     );
//   }
// }
