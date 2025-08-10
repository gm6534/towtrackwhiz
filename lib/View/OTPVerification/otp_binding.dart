import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Other/otp_controller.dart';

class OtpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OtpController());
  }
}
