import 'dart:async';

import 'package:flutter/cupertino.dart';
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

  Future<void> firstApiCall() async {
    await refreshZones();
  }

  Future<void> getCommunityAlertList() async {
    try {
      allAlertsList.value = [];
      if (initialLat.value == 0.0 || initialLong.value == 0.0) {
        await _startLocationWatch();
      }
      final result = await dashboardRepo?.getCommunityAlertList(
        latitude: initialLat.value,
        longitude: initialLong.value,
      );
      if (result != null) {
        allAlertsList.value = result.alerts ?? [];
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
            "${p.street}, ${p.locality}, ${p.administrativeArea}, ${p.country}";
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
      // isVehicleSelected.value = true;
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
      // if (selectedVehicle.value == null) {
      //   isVehicleSelected.value = false;
      // }

      // If any invalid, stop here
      if (!isTypeValid.value ||
          // !isVehicleSelected.value ||
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

  ///<<<<<<<<<<<<<::::::::::::::::::::::::::::::::HEAT MAP WIDGET::::::::::::::::::::::::::::::::::::::::>>>>>>>>>>>>>>>///

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

  void _buildPolygons() {
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
    final posStream = await Helper.getCurrentLocationStream();
    if (posStream == null) return;

    // prevent duplication
    _positionSub?.cancel();

    _positionSub = posStream.listen((pos) {
      initialLat.value = pos.latitude;
      initialLong.value = pos.longitude;
      Log.i(
        ":::::Current Location:::::",
        "${initialLat.value}, ${initialLong.value}",
      );
      final newPoint = LatLng(initialLat.value, initialLong.value);
      currentMarker.value = newPoint;

      if (smartAlertsEnabled) {
        _onLocationUpdate(newPoint);
      }

      // Safe call
      Future.delayed(const Duration(milliseconds: 500), () {
        animateTo(newPoint);
      });
    });
  }

  Future<void> animateTo(LatLng pos) async {
    if (!heatMapControllerCompleter.isCompleted) return; // map not ready
    final controller = await heatMapControllerCompleter.future;
    controller.animateCamera(CameraUpdate.newLatLng(pos));
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
      // cancel and restart timer if requested

      _refreshTimer?.cancel();
      _refreshTimer = Timer.periodic(refreshInterval, (_) => refreshZones());

      // ✅ Always fetch new alerts from API
      await getCommunityAlertList();

      // ✅ Build clusters & polygons
      zones.assignAll(clusterAlerts(allAlertsList));
      _buildPolygons();
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
      final pos = alert.latLng;
      if (pos == null) continue;

      final latKey = (pos.latitude / gridSize).floor();
      final lngKey = (pos.longitude / gridSize).floor();
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
