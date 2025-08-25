import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';
import 'package:towtrackwhiz/Core/Utils/log_util.dart';

import 'Auth/auth_controller.dart';

class InitialController extends GetxController {
  String appLogo = ImgPath.appLogo;
  GetStorage? _getStorage;

  @override
  void onInit() {
    _getStorage = GetStorage();
    navigateToNext();
    super.onInit();
  }

  Future<void> navigateToNext() async {
    final authController = Get.find<AuthController>();
    await 1.seconds.delay();
    bool? isFirstTime = _getStorage?.read(GetStorageKeys.firstTime);
    Log.d("----isFirstTime----", isFirstTime.toString());
    if (isFirstTime == null) {
      _getStorage?.write(GetStorageKeys.firstTime, true);
      Get.offAllNamed(AppRoute.onboarding);
    } else if (authController.isLoggedIn.value) {
      Get.offAllNamed(AppRoute.dashboard);
    } else {
      Get.offAllNamed(AppRoute.getStarted);
    }
  }
}
