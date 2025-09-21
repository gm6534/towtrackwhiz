import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/Constants/app_strings.dart';
import '../../core/Utils/app_colors.dart';
import '../Utils/log_util.dart';
import 'Widgets/toasts.dart';

class PermissionManager {
  static bool _isDialogOpen = false;

  /// 🔹 Keep asking until granted or permanently denied
  static Future<void> enforcePermission(
    Permission permission, {
    required String message,
    Duration interval = const Duration(seconds: 5),
  }) async {
    while (true) {
      final status = await requestPermission(permission, message: message);

      if (status.isGranted) {
        break; // ✅ stop loop if granted
      } else if (status.isPermanentlyDenied) {
        // ❌ stop loop if permanently denied (user must go to settings)
        break;
      }

      // wait before retry
      await Future.delayed(interval);
    }
  }

  /// 🔹 Example for needy permissions
  static Future<bool> requestNeedyPermissions() async {
    try {
      // Location (force user to allow)
      bool locPermission = await _handleLocPermission();
      return locPermission;
      // await enforcePermission(
      //   Platform.isIOS ? Permission.locationAlways : Permission.location,
      //   message: ToastMsg.allowLocationAccess,
      // );
    } catch (e, st) {
      Log.e("::::::PermissionManager::::::", "$e\n$st");
      return false;
    }
  }

  static Future<bool> _handleLocPermission() async {
    // 🔹 Check if location services (GPS) are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ToastAndDialog.showCustomSnackBar(ToastMsg.locationServiceDisabled);
      bool userConfirmed = await ToastAndDialog.confirmation(
        message: ToastMsg.locationServiceDisabled,
        okText: "Open Settings",
        cancelText: "Cancel",
      );
      if (userConfirmed) {
        if (Platform.isIOS) {
          await Geolocator.openLocationSettings();
        } else {
          await Geolocator.openAppSettings();
        }
      }
      // After returning from settings, check again
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ToastAndDialog.showCustomSnackBar(ToastMsg.locationServiceDisabled);
        return false; // ❌ Still disabled
      }
    }

    // 🔹 Check current permission status
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ToastAndDialog.showCustomSnackBar(ToastMsg.locationPermissionDenied);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // ❌ User tapped "Don’t ask again"
      bool userConfirmed = await ToastAndDialog.confirmation(
        title: "Permission Required",
        message:
            "Location permission is required to track your trips. Open Settings to enable it?",
        okText: "Open Settings",
        cancelText: "Cancel",
      );

      if (userConfirmed) {
        await Geolocator.openAppSettings();
      } else {
        ToastAndDialog.showCustomSnackBar(
          ToastMsg.locationPermissionPermanentlyDenied,
          duration: 5,
        );
      }
      return false;
    }

    // 🔹 Handle background location separately
    if (permission == LocationPermission.whileInUse) {
      // On iOS, you must explicitly request background access
      if (GetPlatform.isIOS) {
        LocationPermission bgPermission = await Geolocator.checkPermission();
        if (bgPermission != LocationPermission.always) {
          bool userConfirmed = await ToastAndDialog.confirmation(
            title: "Set Permission to Always",
            message: "Please set location permission to Always in Settings",
            okText: "Open Settings",
            cancelText: "Cancel",
          );
          if (userConfirmed) {
            await Geolocator.openAppSettings();
          }
          Log.w("Location", "Background location not granted");
        }
      }
    }

    return true; // ✅ Permission is granted
  }

  /// 🔹 Base request (your existing logic)
  static Future<PermissionStatus> requestPermission(
    Permission permission, {
    required String message,
  }) async {
    PermissionStatus status = await permission.status;

    if (!status.isGranted) {
      status = await permission.request();
    }

    if (status == PermissionStatus.denied) {
      _showSnack(message);
    } else if (status == PermissionStatus.permanentlyDenied) {
      await _handlePermanentDenial(message);
    } else if (status == PermissionStatus.limited) {
      status = PermissionStatus.granted;
    }

    Log.i(":::::Permission:::::", '${permission.toString()} -> $status');
    return status;
  }

  static Future<void> _handlePermanentDenial(String message) async {
    if (_isDialogOpen) return;
    _isDialogOpen = true;

    final userConfirmed = await ToastAndDialog.confirmation(
      title: Strings.permissionRequired,
      message: "$message. Would you like to open settings and enable it?",
      okText: Strings.openSettings,
      cancelText: ActionText.cancel,
    );

    _isDialogOpen = false;

    if (userConfirmed) {
      await openAppSettings();
    } else {
      _showSnack(message, long: true);
    }
  }

  static void _showSnack(String message, {bool long = false}) {
    if (_isDialogOpen) return;

    ToastAndDialog.showCustomSnackBar(
      message,
      backgroundColor: AppColors.redColor,
      duration: long ? 5 : 2,
    );
  }
}
