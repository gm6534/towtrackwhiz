import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Dashboard/profile_controller.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';
import 'package:towtrackwhiz/View/Profile/my_vehicle.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(30.w),
            decoration: BoxDecoration(
              color: AppColors.lightRed,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, size: 50.w, color: AppColors.redColor),
          ),
          10.verticalSpace,
          Text("Lee Jenna", style: Get.textTheme.headlineMedium),
          Text("leeje24@gmail.com", style: Get.textTheme.bodyLarge),
          Text(
            "Member Since 2025",
            style: Get.textTheme.bodyMedium?.copyWith(
              color: AppColors.greyColor.withValues(alpha: 0.9),
            ),
          ),
          10.verticalSpace,
          Row(
            spacing: 8.w,
            children: [
              SelectionCard(
                icon: ImgPath.alertIcon,
                title: "Alert Require",
                value: "15",
                bgColor: AppColors.lightPrimary,
              ),
              SelectionCard(
                icon: ImgPath.verifyBadge,
                title: "Verified",
                value: "8",
                bgColor: AppColors.lightPrimary,
              ),
              SelectionCard(
                icon: ImgPath.myVehicleIcon,
                title: "Cars Registered",
                value: "9",
                bgColor: AppColors.lightPrimary,
              ),
            ],
          ),
          10.verticalSpace,
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.lightYellowColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              spacing: 10.w,
              children: [
                Image.asset(ImgPath.badgeIcon, height: 30.w, width: 30.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // spacing: 5.w,
                    children: [
                      Text(
                        "Community Helper",
                        style: Get.textTheme.titleMedium,
                      ),
                      Text(
                        "You’ve helped verify 8+ Community alerts",
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: AppColors.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.yellowColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text("Level 2", style: Get.textTheme.labelLarge),
                ),
              ],
            ),
          ),
          10.verticalSpace,
          InkWell(onTap: () => Get.toNamed(AppRoute.myVehicle), child: _menuTile(ImgPath.myVehicleIcon, "My Vehicles")),
          _menuTile(ImgPath.notificationIcon, "Notification Settings"),
          _menuTile(ImgPath.settingIcon, "Account Settings"),
          _menuTile(ImgPath.payMethodIcon, "Payout Method"),
          _menuTile(ImgPath.logoutIcon, "Logout", color: Colors.red),
        ],
      ),
    );
  }

  Widget _menuTile(
    String icon,
    String title, {
    Color color = AppColors.primary,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.white,
      ),
      child: ListTile(
        leading: Image.asset(icon, color: color, height: 20.w, width: 20.w),
        title: Text(title, style: TextStyle(fontSize: 14.sp)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14.sp,
          color: AppColors.primary,
        ),
        onTap: () {},
      ),
    );
  }
}

class SelectionCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final Color bgColor;
  final VoidCallback? onTap;

  const SelectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.bgColor = AppColors.lightPrimary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5.w,
            children: [
              Image.asset(
                icon,
                color: AppColors.primary,
                height: 25.w,
                width: 54.w,
              ),
              Text(value, style: Get.textTheme.titleLarge),
              Text(title, style: Get.textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}
