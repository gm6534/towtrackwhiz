import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';

class ForgetPasswordController extends GetxController{
  final GlobalKey<FormState> forgetPassFormKey = GlobalKey<FormState>();
  

  final emailController = TextEditingController();
  

  void sendCode() {
    Get.offAllNamed(AppRoute.otpScreen);
  }

  
}