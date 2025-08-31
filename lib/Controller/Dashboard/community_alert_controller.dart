import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/toasts.dart';
import 'package:towtrackwhiz/Model/Alerts/community_alert_res_model.dart';
import 'package:towtrackwhiz/Model/Alerts/submit_vote_res_model.dart';
import 'package:towtrackwhiz/Repository/dashboard_repo.dart';

import '../../Core/Common/helper.dart';
import '../../Core/Utils/log_util.dart';

class CommunityAlertController extends GetxController {
  DashboardRepo? dashboardRepo;
  RxList<CommunityAlertsModel> communityAlertsList =
      <CommunityAlertsModel>[].obs;
  RxBool isCommunityAlertLoading = false.obs;
  var submitVoteModel = SubmitVoteResModel().obs;

  @override
  void onInit() {
    dashboardRepo = DashboardRepo();
    getCommunityAlertList();
    super.onInit();
  }

  Future<void> getCommunityAlertList() async {
    try {
      isCommunityAlertLoading.value = true;
      communityAlertsList.value = [];
      final pos = await Helper.getCurrentLocation();
      final result = await dashboardRepo?.getCommunityAlertList(
        latitude: pos?.latitude,
        longitude: pos?.longitude,
      );
      if (result != null) {
        communityAlertsList.value = result.alerts ?? [];
      }
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
        submitVoteModel.value = result;
        submitVoteModel.update((model) {
          model?.upvotes = result.upvotes;
          model?.downvotes = result.downvotes;
        });
        ToastAndDialog.showCustomSnackBar(result.message!);
      }
    } catch (e) {
      Log.d("submitAlertVote - CommunityAlertController", e.toString());
    } finally {
      Get.back();
    }
  }
}
