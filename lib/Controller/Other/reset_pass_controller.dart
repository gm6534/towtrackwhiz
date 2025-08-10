import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';

class ResetPassController extends GetxController{
  final GlobalKey<FormState> resetPassFormKey = GlobalKey<FormState>();
  var isPasswordVisible = false.obs;
  var isConfirmVisible = false.obs;

  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
    isConfirmVisible.value = !isConfirmVisible.value;
  }  

  void save() {
    Get.offAllNamed(AppRoute.loginScreen);
  }

  
}