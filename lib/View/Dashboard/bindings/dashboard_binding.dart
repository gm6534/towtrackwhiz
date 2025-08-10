import 'package:towtrackwhiz/Controller/Other/Dashboard/alert_controller.dart';
import 'package:towtrackwhiz/Controller/Other/Dashboard/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Other/Dashboard/home_controller.dart';
import 'package:towtrackwhiz/Controller/Other/Dashboard/lookup_controller.dart';
import 'package:towtrackwhiz/Controller/Other/Dashboard/profile_controller.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
    //Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => LookupController());
    Get.lazyPut(() => AlertController());
    Get.lazyPut(() => HomeController());

  }
}
