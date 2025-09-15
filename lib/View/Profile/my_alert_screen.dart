import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Dashboard/profile_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/common_app_bar.dart';

import '../Common/alert_card_widget.dart';

class MyAlertScreen extends GetView<ProfileController> {
  const MyAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: commonAppBar,
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: AppColors.primary),
      //   backgroundColor: AppColors.scaffoldBgColor,
      //   surfaceTintColor: AppColors.scaffoldBgColor,
      //   title: Image.asset(ImgPath.appLogo, width: context.width * 0.5),
      // ),
      body: Obx(() {
        if (controller.isAlertRequireLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.myAlertsList.isEmpty) {
          return Center(
            child: Text("No record found", style: context.textTheme.titleLarge),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15.w,
          children: [
            Text("Alert Require", style: Get.textTheme.displaySmall),
            Expanded(
              child: ListView.builder(
                itemCount: controller.myAlertsList.length,
                itemBuilder: (context, index) {
                  final alert = controller.myAlertsList[index];
                  return AlertCardWidget(
                    title: alert.alertType ?? "",
                    location: alert.location ?? "",
                    upVote: alert.upVoteCount.toString(),
                    downVote: alert.downVoteCount.toString(),
                    imgUrl: alert.imagePath ?? "",
                    time: alert.createdAt ?? "",
                    latitude: alert.latitude!,
                    longitude: alert.longitude!,
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
