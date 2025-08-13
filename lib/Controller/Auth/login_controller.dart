import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:towtrackwhiz/Controller/Auth/auth_controller.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';
import 'package:towtrackwhiz/Model/Login/login_response_model.dart';
import 'package:towtrackwhiz/Repository/auth_repo.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  var isPasswordVisible = false.obs;
  var isRememberMe = true.obs;
  GetStorage? _storage;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String? _deviceToken;

  final emailController = TextEditingController(
    text: kDebugMode ? "tcleaner@gmail.com" : "",
  );
  final passwordController = TextEditingController(
    text: kDebugMode ? "12345678" : "",
  );
  LoginResponseModel? loginResponseModel = LoginResponseModel();
  AuthController? authController;

  AuthRepo? authRepo;

  @override
  void onInit() {
    _storage = GetStorage();
    authRepo = AuthRepo();
    super.onInit();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    isRememberMe.value = value ?? false;
  }

  void signUp() {
    Get.toNamed(AppRoute.signUpScreen);
  }

  void login() {
    if (!loginFormKey.currentState!.validate()) return;
    Get.offAllNamed(AppRoute.dashboard);
  }

  // Future<void> login() async {
  //   if (loginFormKey.currentState!.validate()) {
  //     final authController = Get.find<AuthController>();

  //     final email = emailController.text.toString();
  //     final password = passwordController.text.toString();
  //     _deviceToken = await firebaseMessaging.getToken();
  //     final loginResponse = await authController.login(
  //       userName: email,
  //       password: password,
  //       deviceToken: _deviceToken ?? "",
  //     );
  //     if (loginResponse != null) {
  //       if (isRememberMe.value) {
  //         // await _storage!.write(GetStorageKeys.credentials,
  //         //     email + AppInfo.splitSeparator + password);
  //       } else {
  //         await _storage!.write(GetStorageKeys.credentials, null);
  //       }
  //       await _storage!.write(GetStorageKeys.authInfo, loginResponse.toJson());
  //     }
  //   }
  // }
}
