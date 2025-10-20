import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dot_env;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

import '../../Controller/Other/connectivity_controller.dart';
import 'Controller/Auth/auth_controller.dart';

class AppConfig {
  static Future<void> initialize() async {
    await dot_env.dotenv.load();
    Get.put(ConnectionManagerController());
    await GetStorage.init();
    Get.lazyPut(() => AuthController(), fenix: true);
    setSystemChromeTheme();
    setDefaultOrientation();
  }

  static String? get rootURL {
    String? value;
    value = dot_env.dotenv.env["Base_Url"];
    return value;
  }

  static Future<void> setDefaultOrientation() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static Future<void> setSystemChromeTheme() async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppColors.scaffoldBgColor,
        // systemNavigationBarColor: AppColors.scaffoldBgColor,
      ),
      // SystemUiOverlayStyle(
      //   statusBarColor: AppColors.scaffoldBgColor,
      //   statusBarBrightness: Brightness.dark,
      //   statusBarIconBrightness: Brightness.dark,
      //   systemNavigationBarColor: AppColors.scaffoldBgColor,
      //   systemNavigationBarIconBrightness: Brightness.dark,
      // ),
    );
  }
}
