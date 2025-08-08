import 'dart:async';

import 'package:towtrackwhiz/Controller/Auth/auth_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/toasts.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';
import 'package:towtrackwhiz/Model/tasks_list_res_model.dart';
import 'package:towtrackwhiz/Repository/dashboard_repo.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

import '../Core/Constants/app_strings.dart';

class DashboardController extends GetxController {
  RxBool isDashboardLoading = true.obs;
  RxList<TaskModel> taskList = <TaskModel>[].obs;
  AuthController? authController;
  DashboardRepo? dashboardRepo;
  Rx<TaskFilter> selectedFilter = TaskFilter.today.obs;

  ////////////Map Items////////////////
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  ////////////////////////////////////

  @override
  void onInit() {
    authController = Get.find<AuthController>();
    dashboardRepo = DashboardRepo();
    firstApiCall();
    super.onInit();
  }

  Future<void> firstApiCall() async {
    isDashboardLoading.value = true;
    authController?.getUserProfile();
    await getTaskList();
    isDashboardLoading.value = false;
  }

  void navigateToProfile() {
    Get.toNamed(AppRoute.profileScreen);
  }

  Future<void> getTaskList() async {
    try {
      taskList.value = [];
      var result = await dashboardRepo?.getTasksList();
      if (result != null &&
          result.taskModel != null &&
          result.taskModel!.isNotEmpty) {
        taskList.value = result.taskModel ?? [];
      }
    } catch (e) {
      if (e is ClientException) {
        ToastAndDialog.errorDialog(e.message);
      } else {
        ToastAndDialog.errorDialog(e.toString());
      }
    }
  }
}
