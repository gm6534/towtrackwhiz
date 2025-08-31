import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Dashboard/community_alert_controller.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';

import '../../Common/alert_card_widget.dart';

class AlertScreen extends GetView<CommunityAlertController> {
  const AlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15.w,
      children: [
        Text(
          AppHeadings.communityAlerts,
          style: context.textTheme.displaySmall,
        ),
        Expanded(
          child: Obx(() {
            if (controller.isCommunityAlertLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (controller.communityAlertsList.isEmpty) {
              return Center(
                child: Text(
                  Strings.noRecordFound,
                  style: context.textTheme.titleLarge,
                ),
              );
            }
            return ListView.builder(
              itemCount: controller.communityAlertsList.length,
              itemBuilder: (context, index) {
                final alert = controller.communityAlertsList[index];
                controller.submitVoteModel.value.upvotes = int.parse(
                  alert.upvotes.toString(),
                );
                controller.submitVoteModel.value.downvotes = int.parse(
                  alert.downvotes.toString(),
                );
                return AlertCardWidget(
                  title: alert.alertType ?? "",
                  location: alert.location ?? "",
                  imgUrl: alert.imagePath ?? "",
                  time: alert.createdAt ?? "",
                  upVote: controller.submitVoteModel.value.upvotes.toString(),
                  downVote:
                      controller.submitVoteModel.value.downvotes.toString(),
                  onTapUpVote: () async {
                    await controller.submitAlertVote(
                      type: "upvote",
                      id: alert.id,
                    );
                  },
                  onTapDownVote: () async {
                    await controller.submitAlertVote(
                      type: "downvote",
                      id: alert.id,
                    );
                  },
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
