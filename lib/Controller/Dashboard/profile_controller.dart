import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:towtrackwhiz/Controller/Auth/auth_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/toasts.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';
import 'package:towtrackwhiz/Core/Utils/log_util.dart';
import 'package:towtrackwhiz/Model/Alerts/my_alerts_res_model.dart';
import 'package:towtrackwhiz/Model/Auth/auth_response_model.dart';
import 'package:towtrackwhiz/Model/Vehicle/add_vehicle_req_model.dart';
import 'package:towtrackwhiz/Model/analytics_res_model.dart';
import 'package:towtrackwhiz/Repository/auth_repo.dart';
import 'package:towtrackwhiz/Repository/dashboard_repo.dart';

import '../../Core/Common/helper.dart';
import '../../Core/Constants/app_strings.dart';
import '../../Model/Auth/login_req_model.dart';
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

  TextEditingController passwordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();

  RxBool isProfileLoading = false.obs;
  RxBool isVehicleLoading = true.obs;
  RxBool isAlertRequireLoading = true.obs;
  RxList<AlertsModel> myAlertsList = <AlertsModel>[].obs;
  late UserModel originalUser;
  var currentUser = UserModel().obs;
  RxBool isChanged = false.obs;
  var analyticsResModel = AnalyticsResModel().obs;
  RxList<VehiclesListModel> vehiclesList = <VehiclesListModel>[].obs;
  DashboardRepo? dashboardRepo;
  AuthRepo? authRepo;

  AuthController? authController;

  @override
  void onInit() {
    dashboardRepo = DashboardRepo();
    authRepo = AuthRepo();
    authController = Get.find<AuthController>();
    firstApiCall();
    super.onInit();
  }

  Future<void> firstApiCall() async {
    isProfileLoading.value = true;
    getAnalyticsData();
    currentUser.value = (await authController?.getUserProfile())!;
    isNotificationEnabled.value = currentUser.value.isNotify ?? false;
    originalUser = currentUser.value;
    isProfileLoading.value = false;
  }

  void checkChanges() {
    final curr = currentUser.value;
    final orig = originalUser;

    isChanged.value =
        curr.name != orig.name ||
        curr.avatar != orig.avatar ||
        passwordC.text.isNotEmpty ||
        confirmPasswordC.text.isNotEmpty;
  }

  void resetChanges() {
    currentUser.value = originalUser;
    isChanged.value = false;
  }

  Future<void> pickImageFromSource(ImageSource source) async {
    try {
      Permission permission;
      String permissionMessage;

      if (source == ImageSource.camera) {
        permission = Permission.camera;
        permissionMessage = ToastMsg.allowCameraAccess;
      } else {
        permission = Permission.mediaLibrary;
        permissionMessage = ToastMsg.allowGalleryAccess;
      }

      final status = await Helper.requestPermission(
        permission,
        message: permissionMessage,
      );
      if (!status.isGranted) return;

      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 70,
      );

      if (picked != null) {
        updateField(avatar: picked.path);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      ToastAndDialog.errorDialog(e);
    }
  }

  void updateField({String? name, String? avatar}) {
    currentUser.value = UserModel(
      name: name ?? currentUser.value.name,
      email: originalUser.email,
      avatar: avatar ?? currentUser.value.avatar,
      createdAt: currentUser.value.createdAt,
      updatedAt: currentUser.value.updatedAt,
      phone: currentUser.value.phone,
      emailVerifiedAt: currentUser.value.emailVerifiedAt,
      verified: currentUser.value.verified,
      walletBalance: currentUser.value.walletBalance,
      countryId: currentUser.value.countryId,
      status: currentUser.value.status,
      role: currentUser.value.role,
      deviceToken: currentUser.value.deviceToken,
      location: currentUser.value.location,
      lat: currentUser.value.lat,
      lng: currentUser.value.lng,
      streetAddress: currentUser.value.streetAddress,
      deletedAt: currentUser.value.deletedAt,
      level: currentUser.value.level,
      isNotify: currentUser.value.isNotify,
    );

    checkChanges();
  }

  Future<void> updateUserProfile() async {
    if (passwordC.text.isNotEmpty && confirmPasswordC.text.isEmpty) {
      ToastAndDialog.showCustomSnackBar("Both Password will be the same");
      return;
    }
    if (passwordC.text.isEmpty && confirmPasswordC.text.isNotEmpty) {
      ToastAndDialog.showCustomSnackBar("Both Password will be the same");
      return;
    }

    if (passwordC.text.isNotEmpty && passwordC.text.characters.length < 8) {
      ToastAndDialog.showCustomSnackBar(ValidationMessages.shortPassword);
      return;
    }
    if (confirmPasswordC.text.isNotEmpty &&
        confirmPasswordC.text.characters.length < 8) {
      ToastAndDialog.showCustomSnackBar(ValidationMessages.shortPassword);
      return;
    }

    UpdateUserReqModel reqModel = UpdateUserReqModel();
    reqModel.name = currentUser.value.name;
    reqModel.email = currentUser.value.email;
    if (!currentUser.value.avatar!.isURL) {
      reqModel.avatar = currentUser.value.avatar;
    }
    if (passwordC.text.isNotEmpty && confirmPasswordC.text.isNotEmpty) {
      if (passwordC.text == confirmPasswordC.text) {
        reqModel.password = passwordC.text;
        reqModel.confirmPassword = confirmPasswordC.text;
      } else {
        ToastAndDialog.showCustomSnackBar("Both Password will be the same");
        return;
      }
    }
    await authController?.updateProfile(data: reqModel);
    firstApiCall();
    resetChanges();
  }

  Future<void> deleteUserProfile() async {
    await authController?.deleteUser();
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

  Future<void> getMyAlertList() async {
    try {
      isAlertRequireLoading.value = true;
      myAlertsList.value = [];
      Get.toNamed(AppRoute.myAlertScreen);
      final result = await dashboardRepo?.getMyAlertsList();
      if (result != null) {
        myAlertsList.value = result.alerts ?? [];
      }
    } catch (e) {
      if (e is ClientException) {
        ToastAndDialog.showCustomSnackBar(e.message);
      } else {
        ToastAndDialog.showCustomSnackBar(e.toString());
      }
      Log.d("myAlertList - ProfileController", e.toString());
    } finally {
      isAlertRequireLoading.value = false;
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

  Future<void> toggleNotify({bool? value}) async {
    try {
      ToastAndDialog.progressIndicator();
      final result = await authRepo?.toggleNotification(
        toggleValue: value == true ? 1 : 0,
      );
      if (result != null) {
        isNotificationEnabled.value = value!;
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
}
