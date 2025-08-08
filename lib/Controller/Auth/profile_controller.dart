import 'package:towtrackwhiz/Core/Common/Widgets/toasts.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:towtrackwhiz/Model/Login/login_req_model.dart';
import 'package:towtrackwhiz/Model/Login/login_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Core/Common/helper.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  final GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  late UserModel originalUser;
  late Rx<UserModel> currentUser;
  RxBool isChanged = false.obs;
  RxBool isProfileLoading = true.obs;

  TextEditingController passwordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();

  /// Must be called after controller is created

  AuthController? authController;

  @override
  void onInit() {
    authController = Get.find<AuthController>();
    firstApiCall();
    super.onInit();
  }

  Future<void> firstApiCall() async {
    isProfileLoading.value = true;
    if (authController?.authInfo?.user == null ||
        authController?.authInfo?.user?.id == null) {
      await authController?.getUserProfile();
    }
    setUserModel(authController!.authInfo!.user!);

    isProfileLoading.value = false;
  }

  void setUserModel(UserModel user) {
    originalUser = user;
    currentUser = Rx<UserModel>(UserModel.fromJson(user.toJson()));
  }

  UserModel? get userInfo {
    return authController?.authInfo?.user;
  }

  void updateField({
    String? name,
    String? phone,
    String? avatar,
    String? role,
    String? status,
    String? availability,
  }) {
    currentUser.value = UserModel(
      id: originalUser.id,
      name: name ?? currentUser.value.name,
      email: originalUser.email,
      phone: phone ?? currentUser.value.phone,
      avatar: avatar ?? currentUser.value.avatar,
      status: status ?? currentUser.value.status,
      role: role ?? currentUser.value.role,
      availability: availability ?? currentUser.value.availability,
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
    reqModel.phone = currentUser.value.phone;
    await authController?.updateProfile(data: reqModel);
    firstApiCall();
    resetChanges();
  }

  void checkChanges() {
    final curr = currentUser.value;
    final orig = originalUser;

    isChanged.value =
        curr.name != orig.name ||
        curr.phone != orig.phone ||
        curr.avatar != orig.avatar ||
        curr.role != orig.role ||
        curr.status != orig.status ||
        curr.availability != orig.availability ||
        passwordC.text.isNotEmpty ||
        confirmPasswordC.text.isNotEmpty;
  }

  void resetChanges() {
    currentUser.value = UserModel.fromJson(originalUser.toJson());
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
}
