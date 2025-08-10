import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Auth/sign_up_controller.dart';

class SignUpBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
  }
}
