import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Dashboard/home_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/toasts.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';
import 'package:towtrackwhiz/View/Common/report_tow_activity_dialog.dart';

import '../../../View/Dashboard/Alert/alert_screen.dart';
import '../../../View/Dashboard/Home/home_screen.dart';
import '../../../View/Dashboard/LookUp/lookup_screen.dart';
import '../../View/Profile/profile_screen.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;

  HomeController? homeController;
  RxBool isDashboardLoading = false.obs;

  @override
  void onInit() {
    homeController = Get.find<HomeController>();
    firstApiCall();
    super.onInit();
  }

  Future<void> firstApiCall() async {
    isDashboardLoading.value = true;
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

  Future<void> showReportTowActivityDialog() async {
    homeController?.resetDialogData();
    if (homeController!.vehiclesList.isEmpty) {
      ToastAndDialog.progressIndicator(text: "Please wait...\nSetting up".obs);
      var list = await homeController?.getVehicleList();
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      if (list == null || list.isEmpty) {
        ToastAndDialog.showCustomSnackBar(
          "Please registered your vehicle first",
          // title: "Alert",
          backgroundColor: AppColors.redColor
        );

        // ToastAndDialog.showCustomSnackBar(
        //   "Please registered your vehicle first",
        // );
        return;
      }
    }
    Get.dialog(ReportTowActivityDialog());
  }
}
