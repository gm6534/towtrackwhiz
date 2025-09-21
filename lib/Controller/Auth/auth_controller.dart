import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:towtrackwhiz/Core/Routes/app_route.dart';
import 'package:towtrackwhiz/Model/Auth/auth_response_model.dart';
import 'package:towtrackwhiz/Model/Auth/login_req_model.dart';
import 'package:towtrackwhiz/Model/Auth/signup_req_model.dart';
import 'package:towtrackwhiz/Repository/auth_repo.dart';

import '../../Core/Common/Widgets/toasts.dart';
import '../../Core/Common/helper.dart';
import '../../Core/Constants/app_strings.dart';
import '../../Core/Utils/log_util.dart';

class AuthController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  GetStorage? _storage;
  AuthRepo? _authRepo;
  AuthResponseModel? authInfo;

  String? get accessToken {
    return (authInfo != null &&
            authInfo!.token != null &&
            authInfo!.token!.isNotEmpty)
        ? authInfo!.token
        : null;
  }

  set setAuthInfo(value) {
    authInfo = value;
  }

  String get email {
    if (authInfo == null) return "";

    return (authInfo?.user?.email ?? "").trim();
  }

  String get phone {
    if (authInfo == null) return "";

    return (authInfo?.user?.phone ?? "").trim();
  }

  String get fullName {
    if (authInfo == null) return "";

    final firstName = authInfo?.user?.name?.trim() ?? "";

    return firstName.trim();
  }

  String get profileImage {
    if (authInfo == null) return "";

    final img = authInfo?.user?.avatar?.trim() ?? "";

    return img.trim();
  }

  @override
  void onInit() {
    _storage = GetStorage();
    _authRepo = AuthRepo();
    _autoLogin();
    listenAuthLogin();
    super.onInit();
  }

  listenAuthLogin() {
    try {
      _storage!.listenKey(GetStorageKeys.authInfo, (userData) {
        if (userData != null) {
          authInfo = AuthResponseModel.fromJson(userData);
          if (authInfo != null) {
            if (!isLoggedIn.value) {
              isLoggedIn.value = true;
              Get.offAllNamed(AppRoute.dashboard);
            }
          } else {
            userData = null;
          }
        }
        if (userData == null) {
          Get.offAllNamed(AppRoute.getStarted);
        }
      });
    } catch (e) {
      Log.e("listenAuthLogin: -", e.toString());
    }
  }

  Future<void> _autoLogin() async {
    try {
      Map<String, dynamic>? userData;
      userData = _storage!.read(GetStorageKeys.authInfo);
      if (userData != null && userData.isNotEmpty) {
        authInfo = AuthResponseModel.fromJson(userData);
        if (authInfo != null) {
          isLoggedIn.value = true;
          Log.d("AUTH TOKEN: -", authInfo?.toJson().toString());
        }
      }
      //  else {
      //   await logout(justToClear: false);
      // }
    } catch (e) {
      Log.e("_autoLogin: -", e.toString());
    }
  }

  Future<AuthResponseModel?> login({
    required String userName,
    required String password,
    required String deviceToken,
  }) async {
    try {
      ToastAndDialog.progressIndicator();
      LoginReqModel loginModel = LoginReqModel();
      loginModel.password = password;
      loginModel.email = userName;
      loginModel.deviceToken = deviceToken;

      authInfo = await _authRepo?.login(model: loginModel);
      Get.back();
      return authInfo;
    } catch (e) {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      if (e is ClientException) {
        ToastAndDialog.errorDialog(e.message);
      } else {
        ToastAndDialog.errorDialog(e.toString());
      }
    }
    return null;
  }

  Future<AuthResponseModel?> socialLogin({
    required String userName,
    required String deviceToken,
    required String authType,
    required String email,
  }) async {
    try {
      ToastAndDialog.progressIndicator();
      SignupReqModel loginModel = SignupReqModel();
      loginModel.email = email;
      loginModel.name = userName;
      loginModel.authType = authType;
      loginModel.deviceToken = deviceToken;

      authInfo = await _authRepo?.socialLogin(model: loginModel);
      Get.back();
      return authInfo;
    } catch (e) {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      if (e is ClientException) {
        ToastAndDialog.errorDialog(e.message);
      } else {
        ToastAndDialog.errorDialog(e.toString());
      }
    }
    return null;
  }

  Future<AuthResponseModel?> signup({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String deviceToken,
  }) async {
    try {
      ToastAndDialog.progressIndicator();
      SignupReqModel reqModel = SignupReqModel();
      reqModel.password = password;
      reqModel.confirmPassword = confirmPassword;
      reqModel.email = email;
      reqModel.name = name;
      reqModel.deviceToken = deviceToken;

      authInfo = await _authRepo?.signUp(model: reqModel);
      Get.back();
      return authInfo;
    } catch (e) {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      if (e is ClientException) {
        ToastAndDialog.errorDialog(e.message);
      } else {
        ToastAndDialog.errorDialog(e.toString());
      }
    }
    return null;
  }

  Future<void> updateProfile({required UpdateUserReqModel data}) async {
    try {
      ToastAndDialog.progressIndicator();

      var result = await _authRepo?.updateProfile(model: data);

      if (result != null) {
        updateUserInfo(result.user!);
      }

      Get.back();
    } catch (e) {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      ToastAndDialog.errorDialog(e.toString());
    }
  }

  Future<UserModel?> getUserProfile() async {
    try {
      var result = await _authRepo?.getProfile();

      if (result != null) {
        updateUserInfo(result);
      }
      return result;
    } catch (e) {
      Log.e("getUserProfile _ Auth Controller", "$e");
      return authInfo?.user;
    }
  }

  Future<void> deleteUser() async {
    try {
      ToastAndDialog.progressIndicator();
      var result = await _authRepo?.deleteProfile();

      if (result != null) {
        await logout();
        ToastAndDialog.showCustomSnackBar(result);
      }
    } catch (e) {
      Log.e("deleteUser _ Auth Controller", "$e");
    } finally {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  Future<String?> getDeviceToken({
    required FirebaseMessaging firebaseMessaging,
  }) async {
    String? token;
    try {
      // 🔹 Step 1: request notification permission
      final status = await Helper.requestPermission(
        Permission.notification,
        toastDuration: 5,
        message: "Notification permission is required to receive updates",
      );

      if (status != PermissionStatus.granted) {
        return null;
      }

      if (GetPlatform.isIOS) {
        // 🔹 Step 2: wait for APNs token
        final apnsToken = await firebaseMessaging.getAPNSToken();
        if (apnsToken == null) {
          debugPrint("❌ APNs token not available");
          return null;
        }

        // 🔹 Step 3: FCM token after APNs
        await Future.delayed(const Duration(seconds: 2));
        token = await firebaseMessaging.getToken();
      } else {
        // Always safe to request FCM token
        token = await firebaseMessaging.getToken();
      }

      if (token == null) {
        debugPrint("⚠️ Failed to retrieve FCM token");
      } else {
        debugPrint("✅ Device FCM token: $token");
      }
    } catch (e, st) {
      debugPrint("⚠️ Error retrieving device token: $e\n$st");
    }
    return token;
  }

  Future<void> logout({bool justToClear = true}) async {
    try {
      var credentials = _storage!.read(GetStorageKeys.credentials);
      var firstTime = _storage!.read(GetStorageKeys.firstTime);

      authInfo = null;
      isLoggedIn.value = false;
      await _storage!.erase();
      await _storage!.write(GetStorageKeys.credentials, credentials);
      await _storage!.write(GetStorageKeys.firstTime, firstTime);
      if (justToClear) {
        await _storage!.write(GetStorageKeys.authInfo, null);
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Log.d("Logout: -", e.toString());
      ToastAndDialog.errorDialog(e);
    }
  }

  void updateUserInfo(UserModel updatedUser) async {
    if (authInfo != null) {
      authInfo!.user = updatedUser;
      await _storage?.write(GetStorageKeys.authInfo, authInfo?.toJson());
      update();
    }
  }
}
