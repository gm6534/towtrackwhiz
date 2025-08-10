import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';

class OtpController extends GetxController {
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  final otpControllers = List.generate(4, (_) => TextEditingController());

  final emailController = TextEditingController();

  void submit() {
    String otp = otpControllers.map((c) => c.text).join();
    Get.offAllNamed(AppRoute.resetPassScreen);
  }

  void resendCode() {}
}
