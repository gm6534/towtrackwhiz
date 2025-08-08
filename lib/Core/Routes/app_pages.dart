import 'package:towtrackwhiz/View/Auth/bindings/login_binding.dart';
import 'package:towtrackwhiz/View/Auth/login_screen.dart';
import 'package:towtrackwhiz/View/Auth/profile_screen.dart';
import 'package:towtrackwhiz/View/Dashboard/dashboard_screen.dart';
import 'package:towtrackwhiz/View/Initial/initial_binding.dart';
import 'package:towtrackwhiz/View/Initial/splash_screen.dart';
import 'package:get/get.dart';

import '../../View/Auth/bindings/profile_binding.dart';
import '../../View/Dashboard/bindings/dashboard_binding.dart';
import '../../core/Routes/app_route.dart';

class AppPages {
  static List<GetPage> pages = [
    GetPage(
      name: AppRoute.initial,
      page: () => SplashScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoute.loginScreen,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoute.dashboard,
      page: () => DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoute.profileScreen,
      page: () => ProfileScreen(),
      binding: ProfileBinding(),
    ),
  ];
}
