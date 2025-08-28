import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:towtrackwhiz/Controller/Auth/auth_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/toasts.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';
import 'package:towtrackwhiz/Core/Utils/log_util.dart';
import 'package:towtrackwhiz/Model/Vehicle/add_vehicle_req_model.dart';
import 'package:towtrackwhiz/Model/analytics_res_model.dart';
import 'package:towtrackwhiz/Repository/dashboard_repo.dart';

import '../../Model/Vehicle/vehicle_list_model.dart';

class ProfileController extends GetxController {
  var isNotificationEnabled = true.obs;
  final GlobalKey<FormState> addVehicleFormKey = GlobalKey<FormState>();
  final TextEditingController licPlateController = TextEditingController();
  final TextEditingController makeController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController modelYearController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController registerStateController = TextEditingController();
  RxBool isProfileLoading = false.obs;
  RxBool isVehicleLoading = true.obs;
  var analyticsResModel = AnalyticsResModel().obs;
  RxList<VehiclesListModel> vehiclesList = <VehiclesListModel>[].obs;
  DashboardRepo? dashboardRepo;

  AuthController? authController;

  @override
  void onInit() {
    dashboardRepo = DashboardRepo();
    authController = Get.find<AuthController>();
    firstApiCall();
    super.onInit();
  }

  Future<void> firstApiCall() async {
    isProfileLoading.value = true;
    await getAnalyticsData();
    isProfileLoading.value = false;
  }

  Future<void> getAnalyticsData() async {
    try {
      final result = await dashboardRepo?.getAnalytics();
      if (result != null) {
        analyticsResModel.value = result;
      }
    } catch (e) {
      Log.d("getAnalyticsData - ProfileController", e.toString());
    }
  }

  Future<void> getVehicleList() async {
    try {
      isVehicleLoading.value = true;
      vehiclesList.value = [];
      Get.toNamed(AppRoute.myVehicle);
      final result = await dashboardRepo?.getMyVehicleList();
      if (result != null) {
        vehiclesList.value = result.vehicles ?? [];
      }
    } catch (e) {
      if (e is ClientException) {
        ToastAndDialog.showCustomSnackBar(e.message);
      } else {
        ToastAndDialog.showCustomSnackBar(e.toString());
      }
      Log.d("getVehicleList - ProfileController", e.toString());
    } finally {
      isVehicleLoading.value = false;
    }
  }

  Future<void> addVehicle() async {
    try {
      if (!addVehicleFormKey.currentState!.validate()) return;
      ToastAndDialog.progressIndicator();
      AddVehicleReqModel vehicleReqModel = AddVehicleReqModel();
      vehicleReqModel.licensePlate = licPlateController.text.trim();
      vehicleReqModel.make = makeController.text.trim();
      vehicleReqModel.model = modelController.text.trim();
      vehicleReqModel.year = modelYearController.text.trim();
      vehicleReqModel.color = colorController.text.trim();
      vehicleReqModel.registrationState = registerStateController.text.trim();
      final result = await dashboardRepo?.addVehicle(model: vehicleReqModel);
      if (Get.isDialogOpen ?? false) {
        Get.close(2);
      }
      if (result != null) {
        vehiclesList.add(result.vehicle!);
        analyticsResModel.update((v) {
          v?.totalVehicles = vehiclesList.length;
        });
        clearAddVehicleForm();
        ToastAndDialog.showCustomSnackBar(result.message!);
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      if (e is ClientException) {
        ToastAndDialog.showCustomSnackBar(e.message);
      } else {
        ToastAndDialog.showCustomSnackBar(e.toString());
      }
      Log.d("getVehicleList - ProfileController", e.toString());
    }
  }

  Future<void> updateVehicle({required int vid}) async {
    try {
      if (!addVehicleFormKey.currentState!.validate()) return;

      ToastAndDialog.progressIndicator();
      AddVehicleReqModel vehicleReqModel = AddVehicleReqModel();
      vehicleReqModel.licensePlate = licPlateController.text.trim();
      vehicleReqModel.make = makeController.text.trim();
      vehicleReqModel.model = modelController.text.trim();
      vehicleReqModel.year = modelYearController.text.trim();
      vehicleReqModel.color = colorController.text.trim();
      vehicleReqModel.registrationState = registerStateController.text.trim();
      final result = await dashboardRepo?.updateVehicle(
        model: vehicleReqModel,
        vId: vid,
      );
      if (Get.isDialogOpen ?? false) {
        Get.close(2);
      }
      if (result != null) {
        final vIndex = vehiclesList.indexWhere((v) => v.id == vid);
        if (vIndex != -1) {
          vehiclesList[vIndex] = result.vehicle!;
        }
        clearAddVehicleForm();
        ToastAndDialog.showCustomSnackBar(result.message!);
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      if (e is ClientException) {
        ToastAndDialog.showCustomSnackBar(e.message);
      } else {
        ToastAndDialog.showCustomSnackBar(e.toString());
      }
      Log.d("updateVehicle - ProfileController", e.toString());
    }
  }

  Future<void> deleteVehicle({required int vId}) async {
    try {
      ToastAndDialog.progressIndicator();
      final result = await dashboardRepo?.deleteVehicle(vId: vId);
      if (result != null) {
        vehiclesList.removeWhere((v) => v.id == vId);

        analyticsResModel.update((v) {
          v?.totalVehicles = vehiclesList.length;
        });
        ToastAndDialog.showCustomSnackBar(result);
      }
    } catch (e) {
      if (e is ClientException) {
        ToastAndDialog.showCustomSnackBar(e.message);
      } else {
        ToastAndDialog.showCustomSnackBar(e.toString());
      }
      Log.d("getVehicleList - ProfileController", e.toString());
    } finally {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  navigateToUpdateVehicle(VehiclesListModel vehicle) {
    setAddVehicleForm(vehicle);
    // Get.offNamedUntil(
    //   AppRoute.addVehicles,
    //   (route) => route.settings.name == AppRoute.addVehicles,
    //   arguments: vehicle,
    // );
    Get.toNamed(AppRoute.addVehicles, arguments: vehicle);
  }

  void setAddVehicleForm(VehiclesListModel vModel) {
    licPlateController.text = vModel.licensePlate ?? "";
    makeController.text = vModel.make ?? "";
    modelController.text = vModel.model ?? "";
    colorController.text = vModel.color ?? "";
    registerStateController.text = vModel.registrationState ?? "";
    modelYearController.text = "";
  }

  void clearAddVehicleForm() {
    licPlateController.clear();
    makeController.clear();
    modelController.clear();
    colorController.clear();
    registerStateController.clear();
    modelYearController.clear();
  }
}
