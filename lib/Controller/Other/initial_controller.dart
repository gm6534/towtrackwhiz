import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';

class InitialController extends GetxController {
  String appLogo = ImgPath.appLogo;

  @override
  void onInit() {
    navigateToNext();
    super.onInit();
  }

  Future<void> navigateToNext() async {
    // final authController = Get.find<AuthController>();
    await 3.seconds.delay();
    Get.offAllNamed(AppRoute.onboarding);

    // if (authController.isLoggedIn.value) {
    //   Get.offAllNamed(AppRoute.dashboard);
    // } else {
    //   Get.offAllNamed(AppRoute.onboarding);
    // }
  }
}
