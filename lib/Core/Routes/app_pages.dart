import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';
import 'package:towtrackwhiz/View/Auth/bindings/login_binding.dart';
import 'package:towtrackwhiz/View/Auth/bindings/sign_up_binding.dart';
import 'package:towtrackwhiz/View/Auth/login_screen.dart';
import 'package:towtrackwhiz/View/Auth/sign_up_screen.dart';
import 'package:towtrackwhiz/View/Dashboard/bindings/dashboard_binding.dart';
import 'package:towtrackwhiz/View/Dashboard/dashboard_screen.dart';
import 'package:towtrackwhiz/View/GetStarted/get_started_screen.dart';
import 'package:towtrackwhiz/View/Initial/initial_binding.dart';
import 'package:towtrackwhiz/View/Initial/splash_screen.dart';
import 'package:towtrackwhiz/View/Onboarding/onboarding_binding.dart';
import 'package:towtrackwhiz/View/Onboarding/onboarding_screen.dart';
import 'package:towtrackwhiz/View/Profile/my_vehicle.dart';

import '../../View/Profile/account_settings_screen.dart';
import '../../View/Profile/add_edit_vehicle_screen.dart';
import '../../View/Profile/my_alert_screen.dart';
import '../../View/Profile/notification_setting_screen.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: AppRoute.initial,
      page: () => SplashScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoute.onboarding,
      page: () => OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(name: AppRoute.getStarted, page: () => GetStartedScreen()),
    GetPage(
      name: AppRoute.loginScreen,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoute.signUpScreen,
      page: () => SignUpScreen(),
      binding: SignUpBinding(),
    ),

    GetPage(
      name: AppRoute.dashboard,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(name: AppRoute.myVehicle, page: () => VehicleScreen()),
    GetPage(name: AppRoute.addVehicles, page: () => AddEditVehicleScreen()),
    GetPage(
      name: AppRoute.notificationSettingScreen,
      page: () => NotificationSettingScreen(),
    ),
    GetPage(
      name: AppRoute.accountSettingsScreen,
      page: () => AccountSettingsScreen(),
    ),
    GetPage(name: AppRoute.myAlertScreen, page: () => MyAlertScreen()),
  ];
}
