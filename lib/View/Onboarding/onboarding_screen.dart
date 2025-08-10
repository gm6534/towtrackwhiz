import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:towtrackwhiz/Controller/Other/onboarding_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_button.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  final List<Map<String, String>> onboardingData = [
    {"image": ImgPath.tow1, "title": "Find your towed car easily"},
    {
      "image": ImgPath.tow2,
      "title": "Avoid high-risk zones with live heatmaps",
    },
    {"image": ImgPath.tow3, "title": "Help the community & earn rewards"},
  ];

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: controller.skip,
              child: Text(
                "Skip",
                style: Get.textTheme.bodyLarge?.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          30.verticalSpace,
          Image.asset(ImgPath.appLogo),
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: onboardingData.length,
              onPageChanged: controller.onPageChanged,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(onboardingData[index]['image']!, height: 210),
                    Text(
                      onboardingData[index]['title']!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
              spacing: 8.0,
              dotDecoration: DotDecoration(
                width: 8,
                height: 8,
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(4),
              ),
              activeDotDecoration: DotDecoration(
                width: 12, // bigger active dot
                height: 12,
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
              title: controller.currentPage.value == 2 ? "Get Started" : "Next",
              
            ),
          ),
        ],
      ),
    );
  }
}
