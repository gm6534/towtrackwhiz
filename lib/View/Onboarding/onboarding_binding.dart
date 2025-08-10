import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Other/onboarding_controller.dart';

class OnboardingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController());
  }
}
