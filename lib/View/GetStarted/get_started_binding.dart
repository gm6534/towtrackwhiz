import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Other/get_started_controller.dart';

class GetStartedBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GetStartedController());
  }
}
