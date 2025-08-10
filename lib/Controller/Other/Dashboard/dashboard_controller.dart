import 'package:get/get.dart';

import '../../../View/Auth/profile_screen.dart';
import '../../../View/Dashboard/Alert/alert_screen.dart';
import '../../../View/Dashboard/Home/home_screen.dart';
import '../../../View/Dashboard/LookUp/lookup_screen.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;
  final pages = [
    const HomeScreen(),
    const AlertScreen(),
    const LookupScreen(),
    const ProfileScreen(),
  ];

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
