import 'package:get/get.dart';

import '../../../Controller/Dashboard/profile_controller.dart';
import '../../../Controller/Dashboard/alert_controller.dart';
import '../../../Controller/Dashboard/dashboard_controller.dart';
import '../../../Controller/Dashboard/home_controller.dart';
import '../../../Controller/Dashboard/lookup_controller.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController(), fenix: true);
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => LookupController());
    Get.lazyPut(() => AlertController());
    Get.lazyPut(() => HomeController());
  }
}
