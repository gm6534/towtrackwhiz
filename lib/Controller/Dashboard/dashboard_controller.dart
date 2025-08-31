import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Dashboard/home_controller.dart';
import 'package:towtrackwhiz/View/Common/report_tow_activity_dialog.dart';

import '../../../View/Dashboard/Alert/alert_screen.dart';
import '../../../View/Dashboard/Home/home_screen.dart';
import '../../../View/Dashboard/LookUp/lookup_screen.dart';
import '../../View/Profile/profile_screen.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;

  HomeController? homeController;

  @override
  void onInit() {
    homeController = Get.find<HomeController>();
    super.onInit();
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

  void showReportTowActivityDialog() {
    homeController?.resetDialogData();
    Get.dialog(ReportTowActivityDialog());
  }
}
