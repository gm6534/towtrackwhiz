import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:towtrackwhiz/Controller/Auth/auth_controller.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';
import 'package:towtrackwhiz/Model/Auth/auth_response_model.dart';
import 'package:towtrackwhiz/Repository/auth_repo.dart';

import '../../Core/Common/Widgets/toasts.dart';
import '../../Core/Constants/app_strings.dart';
import '../../Core/Utils/log_util.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  var isPasswordVisible = false.obs;
  var isRememberMe = true.obs;
  GetStorage? _storage;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  String? _deviceToken;

  final emailController = TextEditingController(
    text: kDebugMode ? "gmdev4@gmail.com" : "",
  );
  final passwordController = TextEditingController(
    text: kDebugMode ? "12345678" : "",
  );
  AuthResponseModel? loginResponseModel = AuthResponseModel();
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

  // void login() {
  //   if (!loginFormKey.currentState!.validate()) return;
  //   Get.offAllNamed(AppRoute.dashboard);
  // }

  // Future<void> login() async {
  //   if (loginFormKey.currentState!.validate()) {
  //     final authController = Get.find<AuthController>();
  //
  //     final email = emailController.text.toString();
  //     final password = passwordController.text.toString();
  //     // _deviceToken = "eSkWfILmQX-MjLx3boWeCE:APA91bEi4mst6ffUoDl6PPkh1qDrZK0ilFH4j2cISOoBYEvCABujuzfc-aajYX7-UCCTNuRC3zJrD8T1zqiH1teB9O9nvVrei_LVtILnvUY-3sm4uV0e-rQ";
  //     // ✅ Ensure iOS has an APNs token before requesting FCM token
  //     String? apnsToken = await firebaseMessaging.getAPNSToken();
  //     if (apnsToken == null && GetPlatform.isIOS) {
  //       // Wait for APNs to be registered
  //       await Future.delayed(const Duration(seconds: 2));
  //       apnsToken = await firebaseMessaging.getAPNSToken();
  //     }
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

  Future<void> login() async {
    if (loginFormKey.currentState!.validate()) {
      final authController = Get.find<AuthController>();

      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      String? deviceToken = await authController.getDeviceToken(
        firebaseMessaging: firebaseMessaging,
      );
      _deviceToken = deviceToken;
      if (_deviceToken == null) {
        return;
      }

      final loginResponse = await authController.login(
        userName: email,
        password: password,
        deviceToken: _deviceToken ?? "", // fallback if no token
      );

      if (loginResponse != null) {
        if (isRememberMe.value) {
          // await _storage!.write(GetStorageKeys.credentials,
          //     email + AppInfo.splitSeparator + password);
        } else {
          await _storage!.write(GetStorageKeys.credentials, null);
        }
        await _storage!.write(GetStorageKeys.authInfo, loginResponse.toJson());
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
