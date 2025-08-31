import 'package:get/get.dart';

import '../../../Controller/Dashboard/profile_controller.dart';
import '../../../Controller/Dashboard/community_alert_controller.dart';
import '../../../Controller/Dashboard/dashboard_controller.dart';
import '../../../Controller/Dashboard/home_controller.dart';
import '../../../Controller/Dashboard/lookup_controller.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => LookupController(), fenix: true);
    Get.lazyPut(() => CommunityAlertController(), fenix: true);
  }
}
