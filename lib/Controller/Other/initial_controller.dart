import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';
import 'package:get/get.dart';

import '../Auth/auth_controller.dart';

class InitialController extends GetxController {
  //String appName = AppInfo.appTitle;
  String appLogo = ImgPath.appLogo;

  @override
  void onInit() {
    navigateToNext();
    super.onInit();
  }

  Future<void> navigateToNext() async {

    final authController = Get.find<AuthController>();
    // await 3.seconds.delay();
    await Future.delayed(Duration(seconds: 3));
    if (authController.isLoggedIn.value) {
      Get.offAllNamed(AppRoute.dashboard);
    } else {
      Get.offAllNamed(AppRoute.onboarding);
    }
  }
}
