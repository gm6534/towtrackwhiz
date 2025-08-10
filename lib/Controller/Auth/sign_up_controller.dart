import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';

class SignUpController extends GetxController {
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  var isPasswordVisible = false.obs;
  var isConfirmVisible = false.obs;
  var isRememberMe = true.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
    isConfirmVisible.value = !isConfirmVisible.value;
  }

  void loginPage() {
    Get.offAllNamed(AppRoute.loginScreen);
  }

  void signUpPage() {
    Get.offAllNamed(AppRoute.dashboard);
  }
}
