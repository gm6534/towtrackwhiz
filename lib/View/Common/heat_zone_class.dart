// // community_alerts_heatmap.dart
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:towtrackwhiz/Controller/Dashboard/home_controller.dart';
// import 'package:towtrackwhiz/Core/Common/Widgets/toasts.dart';
// import 'package:towtrackwhiz/Core/Utils/app_colors.dart';
//
// import '../../Core/Common/helper.dart';
// import '../../Model/Alerts/community_alert_res_model.dart';
//
// /// ---------------- CLUSTER MODEL ----------------
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
//
// /// ---------------- CLUSTERING FUNCTION ----------------
// List<HeatZone> clusterAlerts(List<CommunityAlertsModel> alerts) {
//   const double gridSize = 0.02; // ≈ 2km grouping
//   final Map<String, List<CommunityAlertsModel>> buckets = {};
//
//   for (final alert in alerts) {
//     final pos = alert.latLng;
//     if (pos == null) continue;
//
//     final latKey = (pos.latitude / gridSize).floor();
//     final lngKey = (pos.longitude / gridSize).floor();
//     final key = '$latKey:$lngKey';
//
//     buckets.putIfAbsent(key, () => []).add(alert);
//   }
//
//   final clusters = <HeatZone>[];
//   buckets.forEach((key, list) {
//     final avgLat =
//         list.map((e) => double.parse(e.latitude!)).reduce((a, b) => a + b) /
//         list.length;
//     final avgLng =
//         list.map((e) => double.parse(e.longitude!)).reduce((a, b) => a + b) /
//         list.length;
//
//     final score = list.length;
//     final alertCount = list.length;
//     final lastUpdated = list
//         .map((e) => DateTime.tryParse(e.createdAt ?? '') ?? DateTime.now())
//         .reduce((a, b) => a.isAfter(b) ? a : b);
//
//     clusters.add(
//       HeatZone(
//         id: key,
//         center: LatLng(avgLat, avgLng),
//         alerts: list,
//         score: score,
//         alertCount: alertCount,
//         lastUpdated: lastUpdated,
//       ),
//     );
//   });
//
//   return clusters;
// }
//
// /// ---------------- HEATMAP WIDGET ----------------
// class HeatmapWidget extends StatefulWidget {
//   final Future<List<CommunityAlertsModel>> Function()? onRefreshZones;
//   final bool smartAlertsEnabled;
//   final void Function(HeatZone zone)? onZoneTap;
//
//   const HeatmapWidget({
//     super.key,
//     this.onRefreshZones,
//     this.smartAlertsEnabled = true,
//     this.onZoneTap,
//   });
//
//   @override
//   State<HeatmapWidget> createState() => _HeatmapWidgetState();
// }
//
// class _HeatmapWidgetState extends State<HeatmapWidget> {
//   late GoogleMapController _mapController;
//   Set<Polygon> _polygons = {};
//   List<HeatZone> _zones = [];
//   Timer? _refreshTimer;
//   StreamSubscription<Position>? _positionSub;
//   LatLng? _currentMarker;
//   bool _isCheckingLocation = false;
//   HomeController? homeController;
//
//   static const Duration refreshInterval = Duration(minutes: 30);
//
//   @override
//   void initState() {
//     super.initState();
//     homeController = Get.find<HomeController>();
//     _loadZones();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _startAutoRefresh();
//       _startLocationWatch();
//     });
//   }
//
//   @override
//   void dispose() {
//     _refreshTimer?.cancel();
//     _positionSub?.cancel();
//     super.dispose();
//   }
//
//   Future<void> _loadZones() async {
//     if (widget.onRefreshZones != null) {
//       final alerts = await widget.onRefreshZones!.call();
//       if (!mounted) return;
//       setState(() {
//         _zones = clusterAlerts(alerts);
//       });
//       _buildPolygons();
//     }
//   }
//
//   // Future<void> _loadZones() async {
//   //   if (widget.onRefreshZones == null) return;
//   //
//   //   try {
//   //     final alerts = await widget.onRefreshZones!.call();
//   //
//   //     if (!mounted) return;
//   //     setState(() {
//   //       _zones = clusterAlerts(alerts);
//   //     });
//   //
//   //     _buildPolygons();
//   //   } catch (e) {
//   //     debugPrint("❌ Failed to load zones: $e");
//   //   }
//   // }
//
//   void _buildPolygons() {
//     final polygons = <Polygon>{};
//     for (final zone in _zones) {
//       final color = _colorFromCategory(
//         zone.colorCategory,
//       ).withValues(alpha: 0.45);
//       polygons.add(
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
//     setState(() => _polygons = polygons);
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
//     widget.onZoneTap?.call(zone);
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: AppColors.scaffoldBgColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(10.r),
//           topRight: Radius.circular(10.r),
//         ),
//       ),
//       builder: (_) => _zoneDetailsSheet(zone),
//     );
//   }
//
//   Widget _zoneDetailsSheet(HeatZone zone) {
//     final formatter = DateFormat.yMMMd().add_jm();
//     return Padding(
//       padding: EdgeInsets.all(16.w),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 12.w,
//                 height: 12.w,
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
//   void _startAutoRefresh() {
//     _refreshTimer?.cancel();
//     _refreshTimer = Timer.periodic(refreshInterval, (_) => _loadZones());
//   }
//
//   // Future<void> _startLocationWatch() async {
//   //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   //   if (!serviceEnabled) return;
//   //
//   //   LocationPermission permission = await Geolocator.checkPermission();
//   //   if (permission == LocationPermission.denied) {
//   //     permission = await Geolocator.requestPermission();
//   //     if (permission == LocationPermission.denied) return;
//   //   }
//   //   if (permission == LocationPermission.deniedForever) return;
//   //
//   //   _positionSub = Geolocator.getPositionStream(
//   //     locationSettings: const LocationSettings(
//   //       accuracy: LocationAccuracy.best,
//   //       distanceFilter: 5,
//   //     ),
//   //   ).listen((pos) {
//   //     final newPoint = LatLng(pos.latitude, pos.longitude);
//   //     setState(() => _currentMarker = newPoint);
//   //
//   //     if (widget.smartAlertsEnabled) {
//   //       _onLocationUpdate(newPoint);
//   //     }
//   //
//   //     _mapController.animateCamera(CameraUpdate.newLatLng(newPoint));
//   //   });
//   // }
//
//   Future<void> _startLocationWatch() async {
//     // ✅ Get stream from your helper
//     final posStream = await Helper.getCurrentLocationStream();
//     if (posStream == null) return;
//
//     // ✅ Subscribe
//     _positionSub = posStream.listen((pos) {
//       final newPoint = LatLng(pos.latitude, pos.longitude);
//
//       setState(() {
//         homeController?.initialLat.value = pos.latitude;
//         homeController?.initialLong.value = pos.longitude;
//         _currentMarker = newPoint;
//       });
//
//       if (widget.smartAlertsEnabled) {
//         _onLocationUpdate(newPoint);
//       }
//
//       _mapController.animateCamera(CameraUpdate.newLatLng(newPoint));
//     });
//   }
//
//   void _onLocationUpdate(LatLng point) {
//     if (_isCheckingLocation) return;
//     _isCheckingLocation = true;
//     try {
//       for (final zone in _zones) {
//         if (zone.score >= 15 && zone.containsPoint(point)) {
//           _showImmediateAlert(zone);
//           break;
//         }
//       }
//     } finally {
//       Future.delayed(
//         const Duration(seconds: 3),
//         () => _isCheckingLocation = false,
//       );
//     }
//   }
//
//   void _showImmediateAlert(HeatZone zone) {
//     showDialog(
//       context: context,
//       builder:
//           (_) => AlertDialog(
//             title: const Text('⚠️ High towing risk'),
//             content: Text(
//               '${zone.alertCount} alerts reported recently in this area. Park with caution.',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('Dismiss'),
//               ),
//             ],
//           ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         GoogleMap(
//           initialCameraPosition: const CameraPosition(
//             target: LatLng(31.4809520, 74.3367858),
//             zoom: 12,
//           ),
//           compassEnabled: false,
//           zoomControlsEnabled: false,
//           polygons: _polygons,
//           onMapCreated: (c) => _mapController = c,
//           markers:
//               _currentMarker == null
//                   ? {}
//                   : {
//                     Marker(
//                       markerId: const MarkerId("me"),
//                       position: _currentMarker!,
//                       infoWindow: const InfoWindow(title: "You"),
//                       icon: BitmapDescriptor.defaultMarkerWithHue(
//                         BitmapDescriptor.hueAzure,
//                       ),
//                     ),
//                   },
//           myLocationEnabled: true,
//           myLocationButtonEnabled: false,
//         ),
//         Positioned(
//           top: 10.w,
//           right: 10.w,
//           child: Column(
//             children: [
//               FloatingActionButton.small(
//                 heroTag: 'refreshHeatmap',
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.r),
//                 ),
//                 backgroundColor: AppColors.primary,
//                 onPressed: () async {
//                   await _loadZones();
//                   ToastAndDialog.showCustomSnackBar("Heatmap refreshed");
//                 },
//                 child: const Icon(Icons.refresh, color: AppColors.white),
//               ),
//               SizedBox(height: 3.w),
//               FloatingActionButton.small(
//                 heroTag: 'legend',
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.r),
//                 ),
//                 backgroundColor: AppColors.primary,
//                 onPressed: () => _showLegend(context),
//                 child: const Icon(Icons.legend_toggle, color: AppColors.white),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _showLegend(BuildContext c) {
//     showModalBottomSheet(
//       context: c,
//       backgroundColor: AppColors.scaffoldBgColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(10.r),
//           topRight: Radius.circular(10.r),
//         ),
//       ),
//       builder: (_) {
//         return Padding(
//           padding: EdgeInsets.all(16.w),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Heatmap legend',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Container(width: 16, height: 16, color: Colors.green),
//                   const SizedBox(width: 8),
//                   const Text('Green: 1–4 alerts (Safe)'),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Container(width: 16, height: 16, color: Colors.orange),
//                   const SizedBox(width: 8),
//                   const Text('Yellow: 5–14 alerts (Caution)'),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   Container(width: 16, height: 16, color: Colors.red),
//                   const SizedBox(width: 8),
//                   const Text('Red: 15+ alerts (High risk)'),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

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
                Text('Yellow: 5–14 alerts (Caution)'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.square, color: Colors.red),
                SizedBox(width: 8),
                Text('Red: 15+ alerts (High risk)'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
