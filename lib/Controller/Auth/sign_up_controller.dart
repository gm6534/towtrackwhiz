import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/toasts.dart';

import '../../Core/Constants/app_strings.dart';
import 'auth_controller.dart';

class SignUpController extends GetxController {
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  var isPasswordVisible = false.obs;
  var isConfirmVisible = false.obs;
  var isRememberMe = true.obs;
  GetStorage? _storage;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  @override
  void onInit() {
    _storage = GetStorage();
    super.onInit();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
    isConfirmVisible.value = !isConfirmVisible.value;
  }

  void loginPage() {
    Get.back();
  }

  // void signUpPage() {
  //   if (!signUpFormKey.currentState!.validate()) return;
  //   Get.back();
  // }

  Future<void> signUp() async {
    if (signUpFormKey.currentState!.validate()) {
      final authController = Get.find<AuthController>();

      final name = nameController.text.toString();
      final email = emailController.text.toString();
      final password = passwordController.text.toString();
      final confirmPass = passwordConfirmController.text.toString();
      final signUpResponse = await authController.signup(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPass,
      );
      if (signUpResponse != null && signUpResponse.user?.id != null) {
        // Get.back();
        ToastAndDialog.showCustomSnackBar(
          "${signUpResponse.user?.email} account has been created successfully",
        );
        if (isRememberMe.value) {
          // await _storage!.write(GetStorageKeys.credentials,
          //     email + AppInfo.splitSeparator + password);
        } else {
          await _storage!.write(GetStorageKeys.credentials, null);
        }
        await _storage!.write(GetStorageKeys.authInfo, signUpResponse.toJson());
      }
    }
  }
}
