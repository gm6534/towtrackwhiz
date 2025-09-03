import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Dashboard/community_alert_controller.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

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
          child: RefreshIndicator(
            backgroundColor: AppColors.white,
            color: AppColors.primary,
            onRefresh: () => controller.getCommunityAlertList(),
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
                  final myUserId =
                      controller.authController?.authInfo?.user?.id.toString();

                  final isUpVoted = alert.isUpVoted(myUserId!);
                  final isDownVoted = alert.isDownVoted(myUserId);

                  return Opacity(
                    opacity: (isUpVoted || isDownVoted) ? 0.3 : 1,
                    child: AlertCardWidget(
                      // tileColor:
                      //     (isUpVoted || isDownVoted)
                      //         ? AppColors.greyColor.withValues(alpha: 0.2)
                      //         : null,
                      title: alert.alertType ?? "",
                      location: alert.location ?? "",
                      imgUrl: alert.imagePath ?? "",
                      time: alert.createdAt ?? "",
                      upVote: alert.upVoteCount.toString(),
                      downVote: alert.downVoteCount.toString(),
                      onTapUpVote: () async {
                        if (isUpVoted || isDownVoted) return;
                        await controller.submitAlertVote(
                          type: "upvote",
                          id: alert.id,
                        );
                      },
                      onTapDownVote: () async {
                        if (isUpVoted || isDownVoted) return;
                        await controller.submitAlertVote(
                          type: "downvote",
                          id: alert.id,
                        );
                      },
                      latitude: alert.latitude!,
                      longitude: alert.longitude!,
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}
