import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Other/forget_password_controller.dart';

class ForgetPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgetPasswordController());
  }
}
