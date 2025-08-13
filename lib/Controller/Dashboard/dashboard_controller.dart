import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:towtrackwhiz/View/Common/report_tow_activity_dialog.dart';

import '../../../View/Dashboard/Alert/alert_screen.dart';
import '../../../View/Dashboard/Home/home_screen.dart';
import '../../../View/Dashboard/LookUp/lookup_screen.dart';
import '../../View/Profile/profile_screen.dart';

class DashboardController extends GetxController {
  final TextEditingController commentController = TextEditingController();
  var currentIndex = 0.obs;
  final List<String> towTypes = [
    "Tow truck seen",
    "Car being towed",
    "Tow signage posted",
  ];

  RxString selectedType = "Tow truck seen".obs;

  ////////////Map Items////////////////
  final Completer<GoogleMapController> mapController =
  Completer<GoogleMapController>();

  ////////////////////////////////////

  final pages = [
    const HomeScreen(),
    const AlertScreen(),
    const LookupScreen(),
    const ProfileScreen(),
  ];

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void showReportTowActivityDialog() {
    Get.dialog(ReportTowActivityDialog());
  }
}
