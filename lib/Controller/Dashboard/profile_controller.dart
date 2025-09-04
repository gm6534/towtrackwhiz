import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:towtrackwhiz/Controller/Auth/auth_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/toasts.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';
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
import '../../Model/earning_res_model.dart';

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
  RxBool isPayoutLoading = false.obs;
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
  var earningResModel = EarningResModel().obs;
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

  void clearVehicleFields() {
    licPlateController.clear();
    makeController.clear();
    modelController.clear();
    modelYearController.clear();
    colorController.clear();
    registerStateController.clear();
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
    final result = await ToastAndDialog.confirmation(
      message: "Are you sure you want to delete your account?",
    );
    if (!result) return;
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
    modelYearController.text = vModel.year ?? "";
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

  Future<void> showYearPicker(BuildContext context) async {
    final now = DateTime.now();
    final int currentYear = now.year;
    final int startYear = 1950;
    final int itemCount = currentYear - startYear + 1;

    // Default selected index = current year
    int selectedIndex = currentYear - startYear;

    // If controller already has a valid year → set as initial
    if (modelYearController.text.isNotEmpty) {
      final parsed = int.tryParse(modelYearController.text);
      if (parsed != null && parsed >= startYear && parsed <= currentYear) {
        selectedIndex = parsed - startYear;
      }
    }

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              // Action bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      final pickedYear = startYear + selectedIndex;
                      modelYearController.text = pickedYear.toString();
                      Navigator.pop(ctx);
                    },
                    child: const Text("Done"),
                  ),
                ],
              ),
              const Divider(height: 1),
              // Cupertino Picker
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedIndex,
                  ),
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    selectedIndex = index;
                  },
                  children: List.generate(
                    itemCount,
                    (index) => Center(
                      child: Text(
                        (startYear + index).toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickColor(BuildContext context) async {
    Color selectedColor = Colors.blue;

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.scaffoldBgColor,
          surfaceTintColor: AppColors.scaffoldBgColor,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          title: const Text("Pick Vehicle Color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                selectedColor = color;
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                ActionText.cancel,
                style: context.textTheme.titleLarge,
              ),
              onPressed: () => Navigator.pop(ctx),
            ),
            TextButton(
              child: Text(
                ActionText.select,
                style: context.textTheme.titleLarge?.copyWith(
                  color: AppColors.primary,
                ),
              ),
              onPressed: () {
                colorController.text =
                    "#${selectedColor.value.toRadixString(16).substring(2).toUpperCase()}";
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }

  Color parseColor(String? hexColor, {Color fallback = Colors.grey}) {
    if (hexColor == null || hexColor.isEmpty) return fallback;

    try {
      String cleaned = hexColor.toUpperCase().replaceAll("#", "");

      // If only RGB (6 chars), prepend full opacity (FF)
      if (cleaned.length == 6) {
        cleaned = "FF$cleaned";
      }

      // If still not valid (should be 8 chars for ARGB), fallback
      if (cleaned.length != 8) return fallback;

      return Color(int.parse("0x$cleaned"));
    } catch (e) {
      return fallback; // In case parsing fails
    }
  }

  Future<void> getEarnings() async {
    try {
      isPayoutLoading.value = true;
      Get.toNamed(AppRoute.payoutScreen);
      final result = await dashboardRepo?.getEarningApi();
      if (result != null) {
        earningResModel.value = result;
      }
    } catch (e) {
      if (e is ClientException) {
        ToastAndDialog.showCustomSnackBar(e.message);
      } else {
        ToastAndDialog.showCustomSnackBar(e.toString());
      }
      Log.d("getEarnings - ProfileController", e.toString());
    } finally {
      isPayoutLoading.value = false;
    }
  }
}
