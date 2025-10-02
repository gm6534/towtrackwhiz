import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:towtrackwhiz/Controller/Dashboard/profile_controller.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';
import 'package:towtrackwhiz/View/Common/earning_progress_card.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppColors.white,
      color: AppColors.primary,
      onRefresh: () => controller.firstApiCall(),
      child: Obx(() {
        if (controller.isProfileLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              20.verticalSpace,
              GestureDetector(
                onTap: () => Get.toNamed(AppRoute.accountSettingsScreen),
                child: Container(
                  height: 120.w,
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                    image:
                        controller.currentUser.value.avatar == null
                            ? null
                            : DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: NetworkImage(
                                controller.currentUser.value.avatar!,
                              ),
                            ),
                  ),
                  child:
                      controller.currentUser.value.avatar == null
                          ? Center(
                            child: Icon(
                              Icons.person,
                              size: 100.w,
                              color: AppColors.white,
                            ),
                          )
                          : null,
                ),
              ),
              10.verticalSpace,
              Text(
                controller.currentUser.value.name ?? "",
                style: Get.textTheme.headlineMedium,
              ),
              Text(
                controller.currentUser.value.email ?? "",
                style: Get.textTheme.bodyLarge,
              ),
              Text(
                "${Strings.memberSince} ${DateFormat("MMM yyyy").format(DateTime.parse(controller.currentUser.value.createdAt!))}",
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyColor.withValues(alpha: 0.9),
                ),
              ),
              10.verticalSpace,
              if (controller.analyticsResModel.value.totalVehicles != null)
                Row(
                  spacing: 8.w,
                  children: [
                    SelectionCard(
                      icon: ImgPath.alertIcon,
                      title: Strings.alertsReported,
                      value:
                          "${controller.analyticsResModel.value.totalAlerts}",
                      bgColor: AppColors.lightPrimary,
                      onTap: controller.getMyAlertList,
                    ),
                    SelectionCard(
                      icon: ImgPath.verifyBadge,
                      title: Strings.verified,
                      value:
                          "${controller.analyticsResModel.value.verifiedAlerts}",
                      bgColor: AppColors.lightPrimary,
                    ),
                    SelectionCard(
                      icon: ImgPath.myVehicleIcon,
                      title: Strings.carsRegistered,
                      value:
                          "${controller.analyticsResModel.value.totalVehicles}",
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
                    Image.asset(
                      ImgPath.badgeIcon,
                      height: 30.w,
                      width: 30.w,
                      color: AppColors.yellowColor,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // spacing: 5.w,
                        children: [
                          Text(
                            AppHeadings.communityHelper,
                            style: Get.textTheme.titleMedium,
                          ),
                          Text(
                            "${Strings.youHaveHelpedVerify} ${int.parse(controller.currentUser.value.verified!) > 0 ? controller.currentUser.value.verified : 0} ${Strings.communityAlerts}",
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
                      child: Text(
                        "${Strings.level} ${controller.currentUser.value.level}",
                        style: Get.textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
              ),
              10.verticalSpace,
              EarningProgressCard(),
              10.verticalSpace,
              _menuTile(
                ImgPath.myVehicleIcon,
                AppHeadings.myVehicles,
                onTap: () => controller.getVehicleList(),
              ),
              _menuTile(
                ImgPath.notificationIcon,
                AppHeadings.notificationSettings,
                onTap: () => Get.toNamed(AppRoute.notificationSettingScreen),
              ),
              _menuTile(
                ImgPath.settingIcon,
                AppHeadings.accountSettings,
                onTap: () => Get.toNamed(AppRoute.accountSettingsScreen),
              ),
              _menuTile(
                ImgPath.payMethodIcon,
                AppHeadings.payoutMethod,
                onTap: controller.goToPayOut,
              ),
              _menuTile(
                ImgPath.logoutIcon,
                ActionText.logout,
                color: Colors.red,
                onTap: controller.authController?.logout,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _menuTile(
    String icon,
    String title, {
    Function()? onTap,
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
        trailing: Image.asset(
          ImgPath.downArrow,
          height: 18.w,
          color: AppColors.primary,
        ),
        onTap: onTap,
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
