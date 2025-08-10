import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Other/Dashboard/dashboard_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/report_tow_activity.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';
import 'package:towtrackwhiz/View/Auth/profile_screen.dart';
import 'package:towtrackwhiz/View/Dashboard/Alert/alert_screen.dart';
import 'package:towtrackwhiz/View/Dashboard/Home/home_screen.dart';
import 'package:towtrackwhiz/View/Dashboard/LookUp/lookup_screen.dart';

class DashboardScreen extends GetView<DashboardController> {
  DashboardScreen({super.key});
  final pages = [
    const HomeScreen(),
    const AlertScreen(),
    const LookupScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BaseScaffold(
        body: pages[controller.currentIndex.value],
        floatingActionButton: Transform.translate(
          offset: const Offset(0, -40),
          child: FloatingActionButton.extended(
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.report, color: AppColors.white),
            label: Text(
              "Report Tow",
              style: Get.textTheme.headlineSmall?.copyWith(
                color: AppColors.white,
              ),
            ),
            onPressed: () {
              Get.bottomSheet(
                const ReportTowActivity(),
                isScrollControlled: true,
                backgroundColor: Colors.white,
              );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.greyColor,
          backgroundColor: AppColors.white,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Alert',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Look Up'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
