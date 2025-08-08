import 'package:towtrackwhiz/Controller/Other/initial_controller.dart';
import 'package:get/get.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InitialController());
  }
}
