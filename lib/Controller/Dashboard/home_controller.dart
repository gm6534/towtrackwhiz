// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:towtrackwhiz/Core/Utils/app_colors.dart';
// import 'package:towtrackwhiz/Model/Alerts/location_model.dart';
// import 'package:towtrackwhiz/Repository/dashboard_repo.dart';
//
// import '../../Core/Common/Widgets/toasts.dart';
// import '../../Core/Common/helper.dart';
// import '../../Core/Constants/app_strings.dart';
// import '../../Core/Utils/log_util.dart';
// import '../../Model/Alerts/community_alert_res_model.dart';
// import '../../Model/Alerts/map_picker_screen.dart';
// import '../../Model/Alerts/report_tow_req_model.dart';
// import '../../Model/Vehicle/vehicle_list_model.dart';
//
// class HomeController extends GetxController {
//   final TextEditingController commentController = TextEditingController();
//   var currentIndex = 0.obs;
//   final List<String> towTypes = TowEvent.values.map((e) => e.label).toList();
//   RxString imagePath = Strings.attachFile.obs;
//   var selectedVehicle = Rxn<VehiclesListModel>();
//   var selectedType = Rxn<TowEvent>();
//   RxBool isTypeValid = true.obs;
//   RxBool isVehicleSelected = true.obs;
//   RxBool isLocationPicked = true.obs;
//   DashboardRepo? dashboardRepo;
//   RxBool isGetLocLoading = false.obs;
//   RxBool isHeatMapLoading = false.obs;
//   RxDouble initialLat = (0.0).obs;
//   RxDouble initialLong = (0.0).obs;
//
//   RxList<VehiclesListModel> vehiclesList = <VehiclesListModel>[].obs;
//   RxList<CommunityAlertsModel> allAlertsList = <CommunityAlertsModel>[].obs;
//
//   ////////////Map Items////////////////
//   final Completer<GoogleMapController> mapController =
//       Completer<GoogleMapController>();
//   final Completer<GoogleMapController> mapController1 =
//       Completer<GoogleMapController>();
//
//   Rxn<LatLng> pickedLocation = Rxn<LatLng>(); // confirmed location
//   Rxn<LatLng> tempLocation = Rxn<LatLng>(); // temporary preview marker
//   RxString pickedAddress = "Tap on map to get location".obs;
//
//   /// Preview marker only
//   void previewMarker(LatLng latLng) {
//     tempLocation.value = latLng;
//   }
//
//   ////////////////////////////////////
//
//   @override
//   void onInit() {
//     dashboardRepo = DashboardRepo();
//     super.onInit();
//   }
//
//   Future<void> firstApiCall() async {
//     await refreshZones();
//   }
//
//   Future<void> getCommunityAlertList() async {
//     try {
//       allAlertsList.value = [];
//       if (initialLat.value == 0.0 || initialLong.value == 0.0) {
//         await _startLocationWatch();
//       }
//       final result = await dashboardRepo?.getCommunityAlertList(
//         latitude: initialLat.value,
//         longitude: initialLong.value,
//       );
//       if (result != null) {
//         allAlertsList.value = result.alerts ?? [];
//       }
//     } catch (e) {
//       Log.d("getCommunityAlertList - Home Controller", e.toString());
//     }
//   }
//
//   void resetDialogData() {
//     isTypeValid.value = true;
//     isVehicleSelected.value = true;
//     isLocationPicked.value = true;
//     commentController.clear();
//     pickedLocation.value = null;
//     selectedVehicle = Rxn<VehiclesListModel>();
//     selectedType = Rxn<TowEvent>();
//     imagePath.value = Strings.attachFile;
//   }
//
//   /// Confirm and set marker
//   Future<void> setMarker() async {
//     if (tempLocation.value == null) return;
//
//     pickedLocation.value = tempLocation.value;
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         tempLocation.value!.latitude,
//         tempLocation.value!.longitude,
//       );
//       if (placemarks.isNotEmpty) {
//         final p = placemarks.first;
//         pickedAddress.value =
//             "${p.street}, ${p.locality}, ${p.administrativeArea}, ${p.country}";
//       }
//     } catch (e) {
//       pickedAddress.value = "No address found";
//     }
//   }
//
//   Future<void> navigateToPickLoc() async {
//     isGetLocLoading.value = true;
//
//     LocationModel? pos;
//
//     if (pickedLocation.value != null) {
//       pos = LocationModel(
//         latitude: pickedLocation.value!.latitude,
//         longitude: pickedLocation.value!.longitude,
//       );
//       // pre-fill preview marker
//       tempLocation.value = pickedLocation.value;
//     } else if (initialLat.value == 0.0 || initialLong.value == 0.0) {
//       pos = await Helper.getCurrentLocation();
//     } else {
//       pos = LocationModel(
//         latitude: initialLat.value,
//         longitude: initialLong.value,
//       );
//     }
//
//     Get.to(
//       () => MapPickerScreen(
//         initialCameraPos: CameraPosition(
//           target: LatLng(pos!.latitude!, pos.longitude!),
//           zoom: 12,
//         ),
//       ),
//     );
//
//     isGetLocLoading.value = false;
//   }
//
//   Future<List<VehiclesListModel>> getVehicleList() async {
//     try {
//       vehiclesList.value = [];
//       final result = await dashboardRepo?.getMyVehicleList();
//       if (result != null) {
//         vehiclesList.value = result.vehicles ?? [];
//       }
//     } catch (e) {
//       Log.d("getVehicleList - ProfileController", e.toString());
//     }
//     return vehiclesList;
//   }
//
//   Future<void> reportTow() async {
//     try {
//       // Reset all validations to true
//       isTypeValid.value = true;
//       // isVehicleSelected.value = true;
//       isLocationPicked.value = true;
//
//       // Validate fields
//       if (pickedLocation.value == null ||
//           pickedLocation.value?.latitude == null ||
//           pickedLocation.value?.longitude == null) {
//         isLocationPicked.value = false;
//       }
//       if (selectedType.value == null) {
//         isTypeValid.value = false;
//       }
//       // if (selectedVehicle.value == null) {
//       //   isVehicleSelected.value = false;
//       // }
//
//       // If any invalid, stop here
//       if (!isTypeValid.value ||
//           // !isVehicleSelected.value ||
//           !isLocationPicked.value) {
//         return ToastAndDialog.showCustomSnackBar("Please select all fields");
//       }
//       // if (pickedLocation.value?.latitude == null ||
//       //     // imagePath.value == Strings.attachFile ||
//       //     selectedType.value == null ||
//       //     selectedVehicle.value == null) {
//       //
//       //   return ToastAndDialog.showCustomSnackBar("Please select all fields");
//       // }
//       ToastAndDialog.progressIndicator();
//       ReportTowReqModel reportTowReqModel = ReportTowReqModel();
//       if (imagePath.value != Strings.attachFile) {
//         reportTowReqModel.image = imagePath.value;
//       }
//       if (pickedLocation.value != null &&
//           pickedLocation.value?.latitude != null &&
//           pickedLocation.value?.longitude != null) {
//         reportTowReqModel.latitude = pickedLocation.value?.latitude.toString();
//         reportTowReqModel.longitude =
//             pickedLocation.value?.longitude.toString();
//         reportTowReqModel.location = "Location";
//       }
//       reportTowReqModel.date = DateFormat("yyyy-MM-dd").format(DateTime.now());
//       if (selectedType.value != null) {
//         reportTowReqModel.alertType = selectedType.value?.name;
//       }
//       reportTowReqModel.comments = commentController.text.trim();
//       reportTowReqModel.vehicleId = selectedVehicle.value?.id;
//       final result = await dashboardRepo?.reportTowApi(
//         model: reportTowReqModel,
//       );
//       if (Get.isDialogOpen ?? false) {
//         Get.close(2);
//       }
//       if (result != null) {
//         ToastAndDialog.showCustomSnackBar(result.message!);
//       }
//     } catch (e) {
//       if (Get.isDialogOpen ?? false) {
//         Get.back();
//       }
//       if (e is ClientException) {
//         ToastAndDialog.showCustomSnackBar(e.message, title: "Error");
//       } else {
//         ToastAndDialog.showCustomSnackBar(e.toString(), title: "Error");
//       }
//       Log.d("reportTow - DashboardController", e.toString());
//     }
//   }
//
//   Future<void> pickImageFromSource(ImageSource source) async {
//     try {
//       Permission permission;
//       String permissionMessage;
//
//       if (source == ImageSource.camera) {
//         permission = Permission.camera;
//         permissionMessage = ToastMsg.allowCameraAccess;
//       } else {
//         permission = Permission.mediaLibrary;
//         permissionMessage = ToastMsg.allowGalleryAccess;
//       }
//
//       final status = await Helper.requestPermission(
//         permission,
//         message: permissionMessage,
//       );
//       if (!status.isGranted) return;
//
//       final picked = await ImagePicker().pickImage(
//         source: source,
//         imageQuality: 70,
//       );
//
//       if (picked != null) {
//         imagePath.value = picked.path;
//       }
//     } catch (e) {
//       if (Get.isDialogOpen == true) {
//         Get.back();
//       }
//       ToastAndDialog.errorDialog(e);
//     }
//   }
//
//   ///<<<<<<<<<<<<<::::::::::::::::::::::::::::::::HEAT MAP WIDGET::::::::::::::::::::::::::::::::::::::::>>>>>>>>>>>>>>>///
//
//   final heatMapControllerCompleter = Completer<GoogleMapController>();
//
//   final polygons = <Polygon>{}.obs;
//   final zones = <HeatZone>[].obs;
//   final currentMarker = Rxn<LatLng>();
//   final isCheckingLocation = false.obs;
//
//   Timer? _refreshTimer;
//   StreamSubscription<Position>? _positionSub;
//
//   static const refreshInterval = Duration(minutes: 30);
//
//   // these will be assigned from widget (not constructor)
//   // Future<List<CommunityAlertsModel>> Function()? onRefreshZones;
//   bool smartAlertsEnabled = true;
//
//   @override
//   void onClose() {
//     _refreshTimer?.cancel();
//     _positionSub?.cancel();
//     super.onClose();
//   }
//
//   void buildPolygons() {
//     final set = <Polygon>{};
//     for (final zone in zones) {
//       final color = _colorFromCategory(
//         zone.colorCategory,
//       ).withValues(alpha: 0.45);
//       set.add(
//         Polygon(
//           polygonId: PolygonId(zone.id),
//           points: zone.polygon,
//           fillColor: color,
//           strokeColor: _colorFromCategory(zone.colorCategory),
//           strokeWidth: 2,
//           consumeTapEvents: true,
//           onTap: () => _onZoneTapped(zone),
//         ),
//       );
//     }
//     polygons.value = set;
//   }
//
//   Color _colorFromCategory(String cat) {
//     switch (cat) {
//       case 'red':
//         return Colors.red;
//       case 'yellow':
//         return Colors.orange;
//       default:
//         return Colors.green;
//     }
//   }
//
//   void _onZoneTapped(HeatZone zone) {
//     Get.bottomSheet(_zoneDetailsSheet(zone));
//   }
//
//   Widget _zoneDetailsSheet(HeatZone zone) {
//     final formatter = DateFormat.yMMMd().add_jm();
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//         color: Colors.white,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 12,
//                 height: 12,
//                 color: _colorFromCategory(zone.colorCategory),
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 '${zone.colorCategory.toUpperCase()} • ${zone.score} pts',
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text('${zone.alertCount} alerts reported recently'),
//           const SizedBox(height: 4),
//           Text(
//             'Last updated: ${formatter.format(zone.lastUpdated)}',
//             style: const TextStyle(fontSize: 12, color: Colors.black54),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// ---------------- LOCATION WATCH ----------------
//   Future<void> _startLocationWatch() async {
//     final posStream = await Helper.getCurrentLocationStream();
//     if (posStream == null) return;
//
//     // prevent duplication
//     _positionSub?.cancel();
//     await 2.seconds.delay();
//     _positionSub = posStream.listen((pos) {
//       initialLat.value = pos.latitude;
//       initialLong.value = pos.longitude;
//       Log.i(
//         ":::::Current Location:::::",
//         "${initialLat.value}, ${initialLong.value}",
//       );
//       final newPoint = LatLng(initialLat.value, initialLong.value);
//       animateMarker(newPoint);
//       // currentMarker.value = newPoint;
//
//       if (smartAlertsEnabled) {
//         _onLocationUpdate(newPoint);
//       }
//
//       // Safe call
//       // Future.delayed(const Duration(milliseconds: 500), () {
//       //   animateTo(newPoint);
//       // });
//     });
//   }
//
//   LatLng? oldPosition;
//
//   Future<void> animateMarker(LatLng newPosition) async {
//     if (oldPosition == null) {
//       oldPosition = newPosition;
//       currentMarker.value = newPosition;
//       return;
//     }
//
//     final startLat = oldPosition!.latitude;
//     final startLng = oldPosition!.longitude;
//     final endLat = newPosition.latitude;
//     final endLng = newPosition.longitude;
//
//     const duration = Duration(seconds: 1);
//     final tick = 20; // 20 fps
//     final step = duration.inMilliseconds ~/ tick;
//     int elapsed = 0;
//
//     Timer.periodic(Duration(milliseconds: step), (timer) {
//       elapsed += step;
//       final t = (elapsed / duration.inMilliseconds).clamp(0.0, 1.0);
//
//       final lat = startLat + (endLat - startLat) * t;
//       final lng = startLng + (endLng - startLng) * t;
//
//       currentMarker.value = LatLng(lat, lng);
//
//       if (t >= 1.0) {
//         timer.cancel();
//         oldPosition = newPosition;
//       }
//     });
//   }
//
//   Future<void> animateTo(LatLng pos) async {
//     if (!heatMapControllerCompleter.isCompleted) return; // map not ready
//     final controller = await heatMapControllerCompleter.future;
//     controller.animateCamera(CameraUpdate.newLatLng(pos));
//   }
//
//   void _onLocationUpdate(LatLng point) {
//     if (isCheckingLocation.value) return;
//     isCheckingLocation.value = true;
//     try {
//       for (final zone in zones) {
//         if (zone.score >= 15 && zone.containsPoint(point)) {
//           _showImmediateAlert(zone);
//           break;
//         }
//       }
//     } finally {
//       Future.delayed(
//         const Duration(seconds: 3),
//         () => isCheckingLocation.value = false,
//       );
//     }
//   }
//
//   void _showImmediateAlert(HeatZone zone) {
//     if (Get.isDialogOpen ?? false) return;
//     Get.dialog(
//       AlertDialog(
//         title: const Text('⚠️ High towing risk'),
//         backgroundColor: AppColors.white,
//         surfaceTintColor: AppColors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.r),
//         ),
//         content: Text('${zone.alertCount} alerts recently. Park with caution.'),
//         actions: [
//           TextButton(onPressed: () => Get.back(), child: const Text('Dismiss')),
//         ],
//       ),
//     );
//   }
//
//   /// ---------------- REFRESH ZONES ----------------
//   Future<void> refreshZones() async {
//     try {
//       isHeatMapLoading.value = true;
//       // cancel and restart timer if requested
//
//       if (_refreshTimer != null) {
//         _refreshTimer?.cancel();
//       }
//       _refreshTimer = Timer.periodic(refreshInterval, (_) => refreshZones());
//
//       // ✅ Always fetch new alerts from API
//       await getCommunityAlertList();
//
//       // ✅ Build clusters & polygons
//       zones.assignAll(clusterAlerts(allAlertsList));
//       buildPolygons();
//     } catch (e) {
//       debugPrint("❌ Failed to refresh zones: $e");
//     } finally {
//       isHeatMapLoading.value = false;
//     }
//   }
//
//   List<HeatZone> clusterAlerts(List<CommunityAlertsModel> alerts) {
//     const double gridSize = 0.02; // ≈ 2km grouping
//     final Map<String, List<CommunityAlertsModel>> buckets = {};
//
//     for (final alert in alerts) {
//       final pos = alert.latLng;
//       if (pos == null) continue;
//
//       final latKey = (pos.latitude / gridSize).floor();
//       final lngKey = (pos.longitude / gridSize).floor();
//       final key = '$latKey:$lngKey';
//
//       buckets.putIfAbsent(key, () => []).add(alert);
//     }
//
//     final clusters = <HeatZone>[];
//     buckets.forEach((key, list) {
//       final avgLat =
//           list.map((e) => double.parse(e.latitude!)).reduce((a, b) => a + b) /
//           list.length;
//       final avgLng =
//           list.map((e) => double.parse(e.longitude!)).reduce((a, b) => a + b) /
//           list.length;
//
//       final score = list.length;
//       final alertCount = list.length;
//       final lastUpdated = list
//           .map((e) => DateTime.tryParse(e.createdAt ?? '') ?? DateTime.now())
//           .reduce((a, b) => a.isAfter(b) ? a : b);
//
//       clusters.add(
//         HeatZone(
//           id: key,
//           center: LatLng(avgLat, avgLng),
//           alerts: list,
//           score: score,
//           alertCount: alertCount,
//           lastUpdated: lastUpdated,
//         ),
//       );
//     });
//
//     return clusters;
//   }
// }
//
// class HeatZone {
//   final String id;
//   final LatLng center;
//   final List<CommunityAlertsModel> alerts;
//   final int score;
//   final int alertCount;
//   final DateTime lastUpdated;
//
//   HeatZone({
//     required this.id,
//     required this.center,
//     required this.alerts,
//     required this.score,
//     required this.alertCount,
//     required this.lastUpdated,
//   });
//
//   /// Build square polygon box around cluster
//   List<LatLng> get polygon {
//     const double boxSize = 0.01; // ≈ 1km
//     return [
//       LatLng(center.latitude - boxSize, center.longitude - boxSize),
//       LatLng(center.latitude - boxSize, center.longitude + boxSize),
//       LatLng(center.latitude + boxSize, center.longitude + boxSize),
//       LatLng(center.latitude + boxSize, center.longitude - boxSize),
//     ];
//   }
//
//   String get colorCategory {
//     if (score >= 15) return 'red';
//     if (score >= 5) return 'yellow';
//     return 'green';
//   }
//
//   bool containsPoint(LatLng p) {
//     const double boxSize = 0.01;
//     return p.latitude >= center.latitude - boxSize &&
//         p.latitude <= center.latitude + boxSize &&
//         p.longitude >= center.longitude - boxSize &&
//         p.longitude <= center.longitude + boxSize;
//   }
// }

// home_controller_fixed.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';
import 'package:towtrackwhiz/Model/Alerts/location_model.dart';
import 'package:towtrackwhiz/Repository/dashboard_repo.dart';

import '../../Core/Common/Widgets/toasts.dart';
import '../../Core/Common/helper.dart';
import '../../Core/Constants/app_strings.dart';
import '../../Core/Utils/log_util.dart';
import '../../Model/Alerts/community_alert_res_model.dart';
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
  RxBool isHeatMapLoading = false.obs;

  /// NOTE: Keep initial values 0.0 but ensure we don't call map with them.
  RxDouble initialLat = (0.0).obs;
  RxDouble initialLong = (0.0).obs;

  RxList<VehiclesListModel> vehiclesList = <VehiclesListModel>[].obs;
  RxList<CommunityAlertsModel> allAlertsList = <CommunityAlertsModel>[].obs;

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

  /// First-call helper — ensures we have a location before doing heavy work.
  Future<void> firstApiCall() async {
    await _ensureLocationAvailable(timeout: const Duration(seconds: 8));
    await refreshZones();
  }

  /// ---------------- COMMUNITY ALERTS ----------------
  Future<void> getCommunityAlertList() async {
    try {
      // Do not clear earlier list until successful fetch to avoid UI flicker
      // But show loading state
      // isHeatMapLoading.value = true;

      // Ensure we have a valid location (try quickly)
      await _ensureLocationAvailable(timeout: const Duration(seconds: 6));

      // If still zero, call API without coords (or you may decide to bail)
      final lat = initialLat.value;
      final lng = initialLong.value;

      final result = await dashboardRepo?.getCommunityAlertList(
        latitude: lat,
        longitude: lng,
      );

      if (result != null) {
        // Defensive: ensure parsed alerts are valid
        final fetched = result.alerts ?? [];
        allAlertsList.value = fetched;
      }
    } catch (e) {
      Log.d("getCommunityAlertList - Home Controller", e.toString());
    }
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
            "${p.street ?? ''}, ${p.locality ?? ''}, ${p.administrativeArea ?? ''}, ${p.country ?? ''}";
      }
    } catch (e) {
      pickedAddress.value = "No address found";
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
      // Try to get a single current location if initial is zero
      final loc = await Helper.getCurrentLocation();
      if (loc != null) {
        pos = loc;
      } else {
        // fallback to some sensible default (e.g., center of city) if you want.
        pos = LocationModel(latitude: 0.0, longitude: 0.0);
      }
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
      isLocationPicked.value = true;

      if (pickedLocation.value == null ||
          pickedLocation.value?.latitude == null ||
          pickedLocation.value?.longitude == null) {
        isLocationPicked.value = false;
      }
      if (selectedType.value == null) {
        isTypeValid.value = false;
      }

      if (!isTypeValid.value || !isLocationPicked.value) {
        return ToastAndDialog.showCustomSnackBar("Please select all fields");
      }

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
        permission = Permission.photos;
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
        final file = await Helper.compressMedia(picked);
        imagePath.value = file!.path;
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      ToastAndDialog.errorDialog(e);
    }
  }

  ///<<<<<<<<<<<<<::::::::::::::::::::::::::::::::HEAT MAP WIDGET::::::::::::::::::::::::::::::::::::::::>>>>>>>>>>>>>>>///

  RxBool isLocServiceEnabled = true.obs;
  RxBool isLocPermissionGranted = true.obs;

  final heatMapControllerCompleter = Completer<GoogleMapController>();

  final polygons = <Polygon>{}.obs;
  final zones = <HeatZone>[].obs;
  final currentMarker = Rxn<LatLng>();
  final isCheckingLocation = false.obs;

  Timer? _refreshTimer;
  StreamSubscription<Position>? _positionSub;

  static const refreshInterval = Duration(minutes: 30);

  // these will be assigned from widget (not constructor)
  // Future<List<CommunityAlertsModel>> Function()? onRefreshZones;
  bool smartAlertsEnabled = true;

  @override
  void onClose() {
    _refreshTimer?.cancel();
    _positionSub?.cancel();
    super.onClose();
  }

  void buildPolygons() {
    final set = <Polygon>{};
    for (final zone in zones) {
      final color = _colorFromCategory(
        zone.colorCategory,
      ).withValues(alpha: 0.45);
      set.add(
        Polygon(
          polygonId: PolygonId(zone.id),
          points: zone.polygon,
          fillColor: color,
          strokeColor: _colorFromCategory(zone.colorCategory),
          strokeWidth: 2,
          consumeTapEvents: true,
          onTap: () => _onZoneTapped(zone),
        ),
      );
    }
    polygons.value = set;
  }

  Color _colorFromCategory(String cat) {
    switch (cat) {
      case 'red':
        return Colors.red;
      case 'yellow':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  void _onZoneTapped(HeatZone zone) {
    Get.bottomSheet(_zoneDetailsSheet(zone));
  }

  Widget _zoneDetailsSheet(HeatZone zone) {
    final formatter = DateFormat.yMMMd().add_jm();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                color: _colorFromCategory(zone.colorCategory),
              ),
              const SizedBox(width: 8),
              Text(
                '${zone.colorCategory.toUpperCase()} • ${zone.score} pts',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('${zone.alertCount} alerts reported recently'),
          const SizedBox(height: 4),
          Text(
            'Last updated: ${formatter.format(zone.lastUpdated)}',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  /// ---------------- LOCATION WATCH ----------------
  Future<void> _startLocationWatch() async {
    // ensure we don't register duplicate streams
    _positionSub?.cancel();

    final posStream = await Helper.getCurrentLocationStream();
    if (posStream == null) {
      // fallback: get single shot location
      final loc = await Helper.getCurrentLocation();
      if (loc != null) {
        initialLat.value = loc.latitude!;
        initialLong.value = loc.longitude!;
        final newPoint = LatLng(initialLat.value, initialLong.value);
        currentMarker.value = newPoint;
        // animate map if ready
        // animateTo(newPoint);
      }
      return;
    }

    // slight delay to avoid subscribe storms
    await 2.seconds.delay();

    _positionSub = posStream.listen((pos) {
      if (pos == null) return;
      initialLat.value = pos.latitude;
      initialLong.value = pos.longitude;
      Log.i(
        ":::::Current Location:::::",
        "${initialLat.value}, ${initialLong.value}",
      );
      final newPoint = LatLng(initialLat.value, initialLong.value);
      animateMarker(newPoint);

      // animate camera once map is ready
      // animateTo(newPoint);

      if (smartAlertsEnabled) {
        _onLocationUpdate(newPoint);
      }
    });
  }

  LatLng? oldPosition;

  Future<void> animateMarker(LatLng newPosition) async {
    if (oldPosition == null) {
      oldPosition = newPosition;
      currentMarker.value = newPosition;
      return;
    }

    final startLat = oldPosition!.latitude;
    final startLng = oldPosition!.longitude;
    final endLat = newPosition.latitude;
    final endLng = newPosition.longitude;

    const duration = Duration(seconds: 1);
    final tick = 20; // 20 fps
    final step = duration.inMilliseconds ~/ tick;
    int elapsed = 0;

    Timer.periodic(Duration(milliseconds: step), (timer) {
      elapsed += step;
      final t = (elapsed / duration.inMilliseconds).clamp(0.0, 1.0);

      final lat = startLat + (endLat - startLat) * t;
      final lng = startLng + (endLng - startLng) * t;

      currentMarker.value = LatLng(lat, lng);

      if (t >= 1.0) {
        timer.cancel();
        oldPosition = newPosition;
      }
    });
  }

  Future<void> animateTo(LatLng pos) async {
    // If map controller is not completed, try to wait a short while then return
    if (!heatMapControllerCompleter.isCompleted) return;
    try {
      final controller = await heatMapControllerCompleter.future;
      controller.animateCamera(CameraUpdate.newLatLng(pos));
    } catch (e) {
      Log.d("animateTo", e.toString());
    }
  }

  void _onLocationUpdate(LatLng point) {
    if (isCheckingLocation.value) return;
    isCheckingLocation.value = true;
    try {
      for (final zone in zones) {
        if (zone.score >= 15 && zone.containsPoint(point)) {
          _showImmediateAlert(zone);
          break;
        }
      }
    } finally {
      Future.delayed(
        const Duration(seconds: 3),
        () => isCheckingLocation.value = false,
      );
    }
  }

  void _showImmediateAlert(HeatZone zone) {
    if (Get.isDialogOpen ?? false) return;
    Get.dialog(
      AlertDialog(
        title: const Text('⚠️ High towing risk'),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        content: Text('${zone.alertCount} alerts recently. Park with caution.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Dismiss')),
        ],
      ),
    );
  }

  /// ---------------- REFRESH ZONES ----------------
  Future<void> refreshZones() async {
    try {
      isHeatMapLoading.value = true;
      isLocServiceEnabled.value = await Geolocator.isLocationServiceEnabled();
      LocationPermission locPermission = await Geolocator.checkPermission();
      isLocPermissionGranted.value =
          locPermission == LocationPermission.always ||
          locPermission == LocationPermission.whileInUse;

      // cancel and restart timer if requested
      _refreshTimer?.cancel();
      _refreshTimer = Timer.periodic(refreshInterval, (_) => refreshZones());

      // Always fetch new alerts from API (make sure location is available)
      await getCommunityAlertList();

      // Build clusters & polygons defensively
      zones.assignAll(clusterAlerts(allAlertsList));
      buildPolygons();
    } catch (e) {
      debugPrint("❌ Failed to refresh zones: $e");
    } finally {
      isHeatMapLoading.value = false;
    }
  }

  List<HeatZone> clusterAlerts(List<CommunityAlertsModel> alerts) {
    const double gridSize = 0.02; // ≈ 2km grouping
    final Map<String, List<CommunityAlertsModel>> buckets = {};

    for (final alert in alerts) {
      // defensive parsing - many APIs return lat/lng as strings
      final latStr = alert.latitude;
      final lngStr = alert.longitude;
      if (latStr == null || lngStr == null) continue;
      double? lat;
      double? lng;
      try {
        lat = double.parse(latStr);
        lng = double.parse(lngStr);
      } catch (_) {
        continue;
      }

      // skip invalid coordinates
      if (lat == 0.0 && lng == 0.0) continue;

      final latKey = (lat / gridSize).floor();
      final lngKey = (lng / gridSize).floor();
      final key = '$latKey:$lngKey';

      buckets.putIfAbsent(key, () => []).add(alert);
    }

    final clusters = <HeatZone>[];
    buckets.forEach((key, list) {
      final avgLat =
          list.map((e) => double.parse(e.latitude!)).reduce((a, b) => a + b) /
          list.length;
      final avgLng =
          list.map((e) => double.parse(e.longitude!)).reduce((a, b) => a + b) /
          list.length;

      final score = list.length;
      final alertCount = list.length;
      final lastUpdated = list
          .map((e) => DateTime.tryParse(e.createdAt ?? '') ?? DateTime.now())
          .reduce((a, b) => a.isAfter(b) ? a : b);

      clusters.add(
        HeatZone(
          id: key,
          center: LatLng(avgLat, avgLng),
          alerts: list,
          score: score,
          alertCount: alertCount,
          lastUpdated: lastUpdated,
        ),
      );
    });

    return clusters;
  }

  /// Ensure we have a valid location if possible. If we can't get a live stream,
  /// try single-shot. This prevents calling APIs with 0,0.
  Future<void> _ensureLocationAvailable({
    Duration timeout = const Duration(seconds: 6),
  }) async {
    if (initialLat.value != 0.0 && initialLong.value != 0.0) return;

    // Try to get a single-shot location first
    try {
      final single = await Helper.getCurrentLocation();
      if (single != null &&
          single.latitude != null &&
          single.longitude != null) {
        initialLat.value = single.latitude!;
        initialLong.value = single.longitude!;
        final newPoint = LatLng(initialLat.value, initialLong.value);
        currentMarker.value = newPoint;
        // animate map if ready
        // animateTo(newPoint);
        // also start watch for continuous updates
        _startLocationWatch();
        return;
      }
    } catch (_) {
      // ignore
    }

    // If not obtained, start watch and wait for first event up to timeout
    try {
      await _startLocationWatch(); // this registers the stream
      final completer = Completer<void>();
      final sub = _positionSub;
      final timer = Timer(timeout, () {
        if (!completer.isCompleted) completer.complete();
      });

      // If subscription already has value via listen, we should return quickly.
      // Wait until initialLat/Long updated or timeout.
      void check() {
        if (initialLat.value != 0.0 && initialLong.value != 0.0) {
          if (!completer.isCompleted) completer.complete();
        }
      }

      // poll small interval to detect update
      final poll = Timer.periodic(const Duration(milliseconds: 200), (_) {
        check();
        // if (initialLat.value != 0.0 && initialLong.value != 0.0) {
        //   poll.cancel();
        // }
      });

      await completer.future;
      timer.cancel();
      poll.cancel();
      sub; // avoid analyzer unused
    } catch (_) {
      // ignore - if still not available we'll proceed with zeros but avoid calling API earlier
    }
  }
}

class HeatZone {
  final String id;
  final LatLng center;
  final List<CommunityAlertsModel> alerts;
  final int score;
  final int alertCount;
  final DateTime lastUpdated;

  HeatZone({
    required this.id,
    required this.center,
    required this.alerts,
    required this.score,
    required this.alertCount,
    required this.lastUpdated,
  });

  /// Build square polygon box around cluster
  List<LatLng> get polygon {
    const double boxSize = 0.01; // ≈ 1km
    return [
      LatLng(center.latitude - boxSize, center.longitude - boxSize),
      LatLng(center.latitude - boxSize, center.longitude + boxSize),
      LatLng(center.latitude + boxSize, center.longitude + boxSize),
      LatLng(center.latitude + boxSize, center.longitude - boxSize),
    ];
  }

  String get colorCategory {
    if (score >= 15) return 'red';
    if (score >= 5) return 'yellow';
    return 'green';
  }

  bool containsPoint(LatLng p) {
    const double boxSize = 0.01;
    return p.latitude >= center.latitude - boxSize &&
        p.latitude <= center.latitude + boxSize &&
        p.longitude >= center.longitude - boxSize &&
        p.longitude <= center.longitude + boxSize;
  }
}
