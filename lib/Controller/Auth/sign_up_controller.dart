import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    Get.back();
  }

  void signUpPage() {
    if (!signUpFormKey.currentState!.validate()) return;
    Get.back();
  }
}
