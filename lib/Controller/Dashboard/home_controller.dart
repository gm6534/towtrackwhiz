import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:towtrackwhiz/Model/Alerts/location_model.dart';
import 'package:towtrackwhiz/Repository/dashboard_repo.dart';

import '../../Core/Common/Widgets/toasts.dart';
import '../../Core/Common/helper.dart';
import '../../Core/Constants/app_strings.dart';
import '../../Core/Utils/log_util.dart';
import '../../Model/Alerts/map_picker_screen.dart';
import '../../Model/Alerts/report_tow_req_model.dart';
import '../../Model/Vehicle/vehicle_list_model.dart';

class HomeController extends GetxController {
  final TextEditingController commentController = TextEditingController();
  var currentIndex = 0.obs;
  final List<String> towTypes = TowEvent.values.map((e) => e.label).toList();
  RxString imagePath = Strings.attachFile.obs;
  var selectedVehicle = Rxn<VehiclesListModel>();
  var selectedType = Rxn<TowEvent>();
  RxBool isTypeValid = true.obs;
  RxBool isVehicleSelected = true.obs;
  RxBool isLocationPicked = true.obs;
  DashboardRepo? dashboardRepo;
  RxBool isGetLocLoading = false.obs;
  RxDouble initialLat = (0.0).obs;
  RxDouble initialLong = (0.0).obs;

  RxList<VehiclesListModel> vehiclesList = <VehiclesListModel>[].obs;

  ////////////Map Items////////////////
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  final Completer<GoogleMapController> mapController1 =
      Completer<GoogleMapController>();

  Rxn<LatLng> pickedLocation = Rxn<LatLng>(); // confirmed location
  Rxn<LatLng> tempLocation = Rxn<LatLng>(); // temporary preview marker
  RxString pickedAddress = "Tap on map to get location".obs;

  /// Preview marker only
  void previewMarker(LatLng latLng) {
    tempLocation.value = latLng;
  }

  ////////////////////////////////////

  @override
  void onInit() {
    dashboardRepo = DashboardRepo();
    super.onInit();
  }

  Future<void> firstApiCall() async {
    await getCurrentLocation();
    getVehicleList();
  }

  void resetDialogData() {
    isTypeValid.value = true;
    isVehicleSelected.value = true;
    isLocationPicked.value = true;
    commentController.clear();
    pickedLocation.value = null;
    selectedVehicle = Rxn<VehiclesListModel>();
    selectedType = Rxn<TowEvent>();
    imagePath.value = Strings.attachFile;
  }

  /// Confirm and set marker
  Future<void> setMarker() async {
    if (tempLocation.value == null) return;

    pickedLocation.value = tempLocation.value;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        tempLocation.value!.latitude,
        tempLocation.value!.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        pickedAddress.value =
            "${p.street}, ${p.locality}, ${p.administrativeArea}, ${p.country}";
      }
    } catch (e) {
      pickedAddress.value = "No address found";
    }
  }

  /// Move camera to current location
  ///
  Future<void> getCurrentLocation() async {
    LocationModel? locationModel = await Helper.getCurrentLocation();
    if (locationModel != null) {
      initialLat.value = locationModel.latitude!;
      initialLong.value = locationModel.longitude!;
    }
  }

  Future<void> navigateToPickLoc() async {
    isGetLocLoading.value = true;

    LocationModel? pos;

    if (pickedLocation.value != null) {
      pos = LocationModel(
        latitude: pickedLocation.value!.latitude,
        longitude: pickedLocation.value!.longitude,
      );
      // pre-fill preview marker
      tempLocation.value = pickedLocation.value;
    } else if (initialLat.value == 0.0 || initialLong.value == 0.0) {
      pos = await Helper.getCurrentLocation();
    } else {
      pos = LocationModel(
        latitude: initialLat.value,
        longitude: initialLong.value,
      );
    }

    Get.to(
      () => MapPickerScreen(
        initialCameraPos: CameraPosition(
          target: LatLng(pos!.latitude!, pos.longitude!),
          zoom: 12,
        ),
      ),
    );

    isGetLocLoading.value = false;
  }

  Future<List<VehiclesListModel>> getVehicleList() async {
    try {
      vehiclesList.value = [];
      final result = await dashboardRepo?.getMyVehicleList();
      if (result != null) {
        vehiclesList.value = result.vehicles ?? [];
      }
    } catch (e) {
      Log.d("getVehicleList - ProfileController", e.toString());
    }
    return vehiclesList;
  }

  Future<void> reportTow() async {
    try {
      // Reset all validations to true
      isTypeValid.value = true;
      isVehicleSelected.value = true;
      isLocationPicked.value = true;

      // Validate fields
      if (pickedLocation.value == null ||
          pickedLocation.value?.latitude == null ||
          pickedLocation.value?.longitude == null) {
        isLocationPicked.value = false;
      }
      if (selectedType.value == null) {
        isTypeValid.value = false;
      }
      if (selectedVehicle.value == null) {
        isVehicleSelected.value = false;
      }

      // If any invalid, stop here
      if (!isTypeValid.value ||
          !isVehicleSelected.value ||
          !isLocationPicked.value) {
        return ToastAndDialog.showCustomSnackBar("Please select all fields");
      }
      // if (pickedLocation.value?.latitude == null ||
      //     // imagePath.value == Strings.attachFile ||
      //     selectedType.value == null ||
      //     selectedVehicle.value == null) {
      //
      //   return ToastAndDialog.showCustomSnackBar("Please select all fields");
      // }
      ToastAndDialog.progressIndicator();
      ReportTowReqModel reportTowReqModel = ReportTowReqModel();
      if (imagePath.value != Strings.attachFile) {
        reportTowReqModel.image = imagePath.value;
      }
      if (pickedLocation.value != null &&
          pickedLocation.value?.latitude != null &&
          pickedLocation.value?.longitude != null) {
        reportTowReqModel.latitude = pickedLocation.value?.latitude.toString();
        reportTowReqModel.longitude =
            pickedLocation.value?.longitude.toString();
        reportTowReqModel.location = "Location";
      }
      reportTowReqModel.date = DateFormat("yyyy-MM-dd").format(DateTime.now());
      if (selectedType.value != null) {
        reportTowReqModel.alertType = selectedType.value?.name;
      }
      reportTowReqModel.comments = commentController.text.trim();
      reportTowReqModel.vehicleId = selectedVehicle.value?.id;
      final result = await dashboardRepo?.reportTowApi(
        model: reportTowReqModel,
      );
      if (Get.isDialogOpen ?? false) {
        Get.close(2);
      }
      if (result != null) {
        ToastAndDialog.showCustomSnackBar(result.message!);
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      if (e is ClientException) {
        ToastAndDialog.showCustomSnackBar(e.message, title: "Error");
      } else {
        ToastAndDialog.showCustomSnackBar(e.toString(), title: "Error");
      }
      Log.d("reportTow - DashboardController", e.toString());
    }
  }

  Future<void> pickImageFromSource(ImageSource source) async {
    try {
      Permission permission;
      String permissionMessage;

      if (source == ImageSource.camera) {
        permission = Permission.camera;
        permissionMessage = ToastMsg.allowCameraAccess;
      } else {
        permission = Permission.mediaLibrary;
        permissionMessage = ToastMsg.allowGalleryAccess;
      }

      final status = await Helper.requestPermission(
        permission,
        message: permissionMessage,
      );
      if (!status.isGranted) return;

      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 70,
      );

      if (picked != null) {
        imagePath.value = picked.path;
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      ToastAndDialog.errorDialog(e);
    }
  }
}
