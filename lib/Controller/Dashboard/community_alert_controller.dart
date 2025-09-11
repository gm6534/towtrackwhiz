import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:towtrackwhiz/Controller/Auth/auth_controller.dart';
import 'package:towtrackwhiz/Controller/Dashboard/home_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/toasts.dart';
import 'package:towtrackwhiz/Model/Alerts/community_alert_res_model.dart';
import 'package:towtrackwhiz/Model/Alerts/submit_vote_res_model.dart';
import 'package:towtrackwhiz/Repository/dashboard_repo.dart';

import '../../Core/Utils/log_util.dart';

class CommunityAlertController extends GetxController {
  DashboardRepo? dashboardRepo;
  AuthController? authController;
  RxList<CommunityAlertsModel> communityAlertsList =
      <CommunityAlertsModel>[].obs;
  var communityAlertsModel = CommunityAlertsModel().obs;
  RxBool isCommunityAlertLoading = false.obs;
  var submitVoteModel = SubmitVoteResModel().obs;
  HomeController? homeController;

  @override
  void onInit() {
    dashboardRepo = DashboardRepo();
    authController = Get.find<AuthController>();
    homeController = Get.find<HomeController>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCommunityAlertScreenList();
    });
    super.onInit();
  }

  Future<void> getCommunityAlertScreenList() async {
    try {
      isCommunityAlertLoading.value = true;
      communityAlertsList.value = [];
      await homeController?.refreshZones();
      communityAlertsList.value = homeController?.allAlertsList ?? [];
    } catch (e) {
      Log.d("getCommunityAlertList - CommunityAlertController", e.toString());
    } finally {
      isCommunityAlertLoading.value = false;
    }
  }

  Future<void> submitAlertVote({String? type, int? id}) async {
    try {
      ToastAndDialog.progressIndicator();
      final result = await dashboardRepo?.submitVote(
        voteType: type!,
        alertId: id!,
      );

      if (result != null) {
        final index = communityAlertsList.indexWhere((a) => a.id == id);
        if (index != -1) {
          final myUserId = authController?.authInfo?.user?.id.toString();

          if (type == "upvote") {
            communityAlertsList[index].upVoteCount = result.upvotes ?? 0;
            communityAlertsList[index].downVoteCount = result.downvotes ?? 0;

            // push my vote locally
            communityAlertsList[index].upvotes ??= [];
            communityAlertsList[index].upvotes!.add(
              VoteModel(userId: myUserId, alertId: id.toString()),
            );
          } else if (type == "downvote") {
            communityAlertsList[index].upVoteCount = result.upvotes ?? 0;
            communityAlertsList[index].downVoteCount = result.downvotes ?? 0;

            communityAlertsList[index].downvotes ??= [];
            communityAlertsList[index].downvotes!.add(
              VoteModel(userId: myUserId, alertId: id.toString()),
            );
          }

          communityAlertsList.refresh(); // 🔑 forces UI update
        }

        ToastAndDialog.showCustomSnackBar(result.message!);
      }

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      if (e is ClientException) {
        ToastAndDialog.errorDialog(e.message);
      } else {
        ToastAndDialog.showCustomSnackBar(e.toString());
      }
      Log.d("submitAlertVote - CommunityAlertController", e.toString());
    }
  }

  // Future<void> submitAlertVote({String? type, int? id}) async {
  //   try {
  //     ToastAndDialog.progressIndicator();
  //     final result = await dashboardRepo?.submitVote(
  //       voteType: type!,
  //       alertId: id!,
  //     );
  //     if (result != null) {
  //       submitVoteModel.value = result;
  //       // find the alert in list and update its values
  //       final index = communityAlertsList.indexWhere((a) => a.id == id);
  //       if (index != -1) {
  //         communityAlertsList[index].upVoteCount = result.upvotes ?? 0;
  //         communityAlertsList[index].downVoteCount = result.downvotes ?? 0;
  //         communityAlertsList.refresh(); // 🔑 notify UI
  //       }
  //
  //       // submitVoteModel.update((model) {
  //       //   model?.upvotes = result.upvotes;
  //       //   model?.downvotes = result.downvotes;
  //       // });
  //       ToastAndDialog.showCustomSnackBar(result.message!);
  //     }
  //     if (Get.isDialogOpen ?? false) {
  //       Get.back();
  //     }
  //   } catch (e) {
  //     if (Get.isDialogOpen ?? false) {
  //       Get.back();
  //     }
  //     if (e is ClientException) {
  //       ToastAndDialog.errorDialog(e.message);
  //     } else {
  //       ToastAndDialog.showCustomSnackBar(e.toString());
  //     }
  //     Log.d("submitAlertVote - CommunityAlertController", e.toString());
  //   }
  // }
}
