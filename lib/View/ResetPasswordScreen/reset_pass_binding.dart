import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Other/reset_pass_controller.dart';

class ResetPassBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ResetPassController());
  }
}