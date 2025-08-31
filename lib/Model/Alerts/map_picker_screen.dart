import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:towtrackwhiz/Controller/Dashboard/home_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';

class MapPickerScreen extends GetView<HomeController> {
  final CameraPosition? initialCameraPos;

  const MapPickerScreen({this.initialCameraPos, super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(title: const Text("Pick Location")),
      body: Obx(() {
        if (controller.isGetLocLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return GoogleMap(
          initialCameraPosition:
              initialCameraPos ??
              const CameraPosition(target: LatLng(31.5204, 74.3587), zoom: 12),
          onMapCreated: (mapCtrl) {
            if (!controller.mapController1.isCompleted) {
              controller.mapController1.complete(mapCtrl);
            }
            mapCtrl.animateCamera(
              CameraUpdate.newCameraPosition(initialCameraPos!),
            );
          },
          markers:
              controller.pickedLocation.value != null
                  ? {
                    Marker(
                      markerId: const MarkerId("picked"),
                      position: controller.pickedLocation.value!,
                    ),
                  }
                  : {},
          onTap: (latLng) => controller.setMarker(latLng),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          // mapToolbarEnabled: ,
        );
      }),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => controller.goToCurrentLocation(),
      //   child: const Icon(Icons.my_location),
      // ),
    );
  }
}
