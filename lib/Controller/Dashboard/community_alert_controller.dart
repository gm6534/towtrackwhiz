import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

  // Future<void> getCommunityAlertScreenList() async {
  //   try {
  //     isCommunityAlertLoading.value = true;
  //     communityAlertsList.value = [];
  //     await homeController?.refreshZones();
  //     communityAlertsList.value = homeController?.allAlertsList ?? [];
  //   } catch (e) {
  //     Log.d("getCommunityAlertList - CommunityAlertController", e.toString());
  //   } finally {
  //     isCommunityAlertLoading.value = false;
  //   }
  // }

  Future<void> getCommunityAlertScreenList() async {
    try {
      isCommunityAlertLoading.value = true;
      communityAlertsList.value = [];
      await homeController?.refreshZones();

      List<CommunityAlertsModel> alerts = homeController?.allAlertsList ?? [];

      // ✅ Sort by latest first (descending)
      alerts.sort(
        (a, b) => DateTime.parse(
          b.createdAt ?? "",
        ).compareTo(DateTime.parse(a.createdAt ?? "")),
      );

      communityAlertsList.value = alerts;
    } catch (e) {
      Log.d("getCommunityAlertList - CommunityAlertController", e.toString());
    } finally {
      isCommunityAlertLoading.value = false;
    }
  }

  Future<bool> isWithinOneMile(double alertLat, double alertLng) async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final distanceInMeters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      alertLat,
      alertLng,
    );

    return distanceInMeters <= 1609.34; // ~1 mile in meters
  }

  Future<void> submitAlertVote({String? type, int? id}) async {
    try {
      // 🔹 find alert first
      final alert = communityAlertsList.firstWhereOrNull((a) => a.id == id);
      if (alert == null) {
        ToastAndDialog.showCustomSnackBar("Alert not found.");
        return;
      }

      // 🔹 check distance before API call
      final isNearby = await isWithinOneMile(
        double.parse(alert.latitude ?? "0.0"),
        double.parse(alert.longitude ?? "0.0"),
      );
      if (!isNearby) {
        ToastAndDialog.showCustomSnackBar(
          "Too far to verify – Looks like you’re not close enough to this alert to verify it. Check for other nearby alerts or report your own sighting.",
        );
        return;
      }

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
