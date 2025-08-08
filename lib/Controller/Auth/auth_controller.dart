import 'package:towtrackwhiz/Core/Routes/app_route.dart';
import 'package:towtrackwhiz/Model/Login/login_req_model.dart';
import 'package:towtrackwhiz/Model/Login/login_response_model.dart';
import 'package:towtrackwhiz/Repository/auth_repo.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import '../../Core/Common/Widgets/toasts.dart';
import '../../Core/Constants/app_strings.dart';
import '../../Core/Utils/log_util.dart';

class AuthController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  GetStorage? _storage;
  AuthRepo? _authRepo;
  LoginResponseModel? authInfo;

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
          authInfo = LoginResponseModel.fromJson(userData);
          if (authInfo != null) {
            if (!isLoggedIn.value) {
              isLoggedIn.value = true;
              Get.offNamed(AppRoute.dashboard);
            }
          } else {
            userData = null;
          }
        }
        if (userData == null) {
          Get.offAllNamed(AppRoute.loginScreen);
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
        authInfo = LoginResponseModel.fromJson(userData);
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

  Future<LoginResponseModel?> login({
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

  Future<void> getUserProfile() async {
    try {
      var result = await _authRepo?.getProfile();

      if (result != null) {
        updateUserInfo(result);
      }
    } catch (e) {
      Log.e("getUserProfile _ Auth Controller", "$e");
    }
  }

  Future<void> logout({bool justToClear = true}) async {
    try {
      // ToastAndDialog.progressIndicator();
      //
      // bool? result = await _authRepository!.logOut();
      // if (result != null && result) {
      var credentials = _storage!.read(GetStorageKeys.credentials);
      var countryCode = _storage!.read(GetStorageKeys.countryCode);
      var languageCode = _storage!.read(GetStorageKeys.languageCode);
      // if (Get.isDialogOpen ?? false) {
      //   Get.back();
      // }
      authInfo = null;
      isLoggedIn.value = false;
      await _storage!.erase();
      await _storage!.write(GetStorageKeys.credentials, credentials);
      await _storage!.write(GetStorageKeys.countryCode, countryCode);
      await _storage!.write(GetStorageKeys.languageCode, languageCode);
      if (justToClear) {
        await _storage!.write(GetStorageKeys.authInfo, null);
      }
      // } else {
      //   // if (Get.isDialogOpen ?? false) {
      //   //   Get.back();
      //   // }
      //   ToastAndDialog.showCustomSnackBar("Some thing went wrong.");
      // }
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
