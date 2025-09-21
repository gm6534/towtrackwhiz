import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/toasts.dart';

import '../../Core/Constants/app_strings.dart';
import '../../Core/Utils/log_util.dart';
import 'auth_controller.dart';

class SignUpController extends GetxController {
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  var isPasswordVisible = false.obs;
  var isConfirmVisible = false.obs;
  var isRememberMe = true.obs;
  GetStorage? _storage;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String? _deviceToken;

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
      String? deviceToken = await authController.getDeviceToken(
        firebaseMessaging: firebaseMessaging,
      );
      _deviceToken = deviceToken;
      if (_deviceToken == null) {
        return;
      }
      final signUpResponse = await authController.signup(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPass,
        deviceToken: _deviceToken ?? "",
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

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>['email']);
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      // final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      if (googleUser != null) {
        final authController = Get.find<AuthController>();
        final email = googleUser.email;
        final name = googleUser.displayName ?? "";
        String? deviceToken = await authController.getDeviceToken(
          firebaseMessaging: firebaseMessaging,
        );
        _deviceToken = deviceToken;
        if (_deviceToken == null) {
          return;
        }
        final loginResponse = await authController.socialLogin(
          userName: name,
          email: email,
          authType: 'google',
          deviceToken: _deviceToken ?? "",
        );
        if (loginResponse != null) {
          // await _storage!.write(GetStorageKeys.credentials, null);
          await _storage!.write(
            GetStorageKeys.authInfo,
            loginResponse.toJson(),
          );
        }
      }
    } on Exception catch (e) {
      Log.d('signInWithGoogle:', '$e');
    }
  }

  Future<void> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final userName = credential.givenName ?? "";
      final email = credential.email ?? "";
      if (userName.isEmpty || email.isEmpty) {
        ToastAndDialog.errorDialog("User name or email cannot be empty");
        return;
      }
      if (credential.userIdentifier != null) {
        final authController = Get.find<AuthController>();
        String? deviceToken = await authController.getDeviceToken(
          firebaseMessaging: firebaseMessaging,
        );
        _deviceToken = deviceToken;
        if (_deviceToken == null) {
          return;
        }
        final loginResponse = await authController.socialLogin(
          userName: userName,
          email: email,
          authType: 'apple',
          deviceToken: _deviceToken ?? "",
        );
        if (loginResponse != null) {
          await _storage!.write(
            GetStorageKeys.authInfo,
            loginResponse.toJson(),
          );
        }
      }
    } on Exception catch (e) {
      Log.d('signInWithApple:', '$e');
    }
  }
}
