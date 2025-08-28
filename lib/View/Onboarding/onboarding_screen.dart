import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:towtrackwhiz/Controller/onboarding_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  final List<Map<String, String>> onboardingData = [
    {"image": ImgPath.tow1Png, "title": "Find your towed car easily"},
    {
      "image": ImgPath.tow2Png,
      "title": "Avoid high-risk zones with live heatmaps",
    },
    {"image": ImgPath.tow2Png, "title": "Help the community & earn rewards"},
  ];

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20.w,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: controller.skip,
                  child: Text(
                    "Skip",
                    style: Get.textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              30.verticalSpace,
              Image.asset(ImgPath.appLogo, width: 300.w),
              Flexible(
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: controller.onPageChanged,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 40.w,
                      children: [
                        Image.asset(onboardingData[index]['image']!),
                        Text(
                          onboardingData[index]['title']!,
                          style: Get.textTheme.headlineLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
              1.verticalSpace,
              SmoothPageIndicator(
                controller: controller.pageController,
                count: onboardingData.length,
                effect: CustomizableEffect(
                  spacing: 8.w,
                  dotDecoration: DotDecoration(
                    width: 8.w,
                    height: 8.w,
                    color: AppColors.greyColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  activeDotDecoration: DotDecoration(
                    width: 12.w, // bigger active dot
                    height: 12.w,
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onDotClicked: (index) {
                  controller.pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              30.verticalSpace,
              Obx(
                () => AppButton(
                  onPressed: controller.nextPage,
                  title:
                      controller.currentPage.value == 2
                          ? "Get Started"
                          : "Next",
                ),
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
