import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:towtrackwhiz/Controller/Dashboard/home_controller.dart';
import 'package:towtrackwhiz/View/Common/report_tow_activity_dialog.dart';

import '../../../View/Dashboard/Alert/alert_screen.dart';
import '../../../View/Dashboard/Home/home_screen.dart';
import '../../../View/Dashboard/LookUp/lookup_screen.dart';
import '../../Core/Common/permission_manager.dart';
import '../../View/Profile/profile_screen.dart';
import '../Scheduler/scheduler_controller.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;

  HomeController? homeController;
  RxBool isDashboardLoading = false.obs;
  Directory? tempDirectory;

  @override
  void onInit() {
    homeController = Get.find<HomeController>();
    setTempDevicePath();
    firstApiCall();
    super.onInit();
  }

  Future<void> firstApiCall() async {
    isDashboardLoading.value = true;
    await PermissionManager.requestNeedyPermissions();
    Get.put(SchedulerController());
    await homeController?.firstApiCall();
    isDashboardLoading.value = false;
  }

  final pages = [
    const HomeScreen(),
    const AlertScreen(),
    const LookupScreen(),
    const ProfileScreen(),
  ];

  void changeTab(int index) {
    currentIndex.value = index;
  }

  Future<void> setTempDevicePath() async {
    tempDirectory = await path_provider.getTemporaryDirectory();
  }

  Future<void> showReportTowActivityDialog() async {
    // if (!homeController!.isLocServiceEnabled.value ||
    //     !homeController!.isLocPermissionGranted.value) {
    //   ToastAndDialog.showCustomSnackBar(
    //     "Please enable location services and allow location access",
    //     duration: 5,
    //   );
    //   return;
    // }
    homeController?.resetDialogData();
    Get.dialog(ReportTowActivityDialog(), barrierDismissible: false);
  }
}
