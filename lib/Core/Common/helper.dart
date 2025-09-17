import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/Alerts/location_model.dart';
import '../../core/Utils/app_colors.dart';
import '../Constants/app_strings.dart';
import '../Utils/log_util.dart';
import 'Widgets/toasts.dart';

class Helper {
  static Future<PermissionStatus> requestPermission(
    Permission permission, {
    String? message,
    bool isContext = false,
  }) async {
    PermissionStatus status = PermissionStatus.denied;

    final serviceStatus = await permission.isGranted;
    if (!serviceStatus) {
      status = await permission.request();
    } else {
      status = PermissionStatus.granted;
    }

    if (status == PermissionStatus.denied) {
      ToastAndDialog.showCustomSnackBar(
        message!,
        backgroundColor: AppColors.redColor,
      );
    } else if (status == PermissionStatus.permanentlyDenied) {
      // await openAppSettings();

      bool userConfirmed = await ToastAndDialog.confirmation(
        title: Strings.permissionRequired,
        message: "$message. Would you like to open settings and enable it?",
        okText: Strings.openSettings,
        cancelText: ActionText.cancel,
      );

      if (userConfirmed) {
        // If user confirms, open app settings
        await openAppSettings();
      } else {
        ToastAndDialog.showCustomSnackBar(
          message!,
          backgroundColor: AppColors.redColor,
          duration: 5,
        );
      }
    } else if (status == PermissionStatus.limited) {
      status = PermissionStatus.granted;
    }
    Log.i("Permission", '$status');

    return status;
  }

  static void launchUrlMethod(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception(ToastMsg.linkError);
      }
    } catch (e) {
      ToastAndDialog.showCustomSnackBar(ToastMsg.linkError);
    }
  }

  static Future<void> unFocusScope() async {
    try {
      var focus = FocusManager.instance.primaryFocus;
      if (focus != null && focus.hasFocus) {
        focus.unfocus();
      }
    } catch (e) {
      Log.e('unFocusScope:', '$e');
    }
  }

  static Future<bool> _handleLocPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false; // ❌ denied again
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // ❌ User selected "Don't ask again" → open settings
      await Geolocator.openAppSettings();
      return false;
    }

    return true; // ✅ granted
  }

  static Future<LocationModel?> getCurrentLocation() async {
    try {
      bool hasPermission = await _handleLocPermission();
      if (!hasPermission) return null;

      LocationModel? locationModel = LocationModel();
      // Stream<Position>  position = Geolocator.getPositionStream(
      //   locationSettings: GetPlatform.isAndroid
      //       ? AndroidSettings(
      //           accuracy: LocationAccuracy.high,
      //         )
      //       : GetPlatform.isIOS
      //           ? AppleSettings(
      //               accuracy: LocationAccuracy.high,
      //             )
      //           : const LocationSettings(
      //               accuracy: LocationAccuracy.high,
      //             ),
      // );
      Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            GetPlatform.isAndroid
                ? AndroidSettings(accuracy: LocationAccuracy.high)
                : GetPlatform.isIOS
                ? AppleSettings(accuracy: LocationAccuracy.high)
                : const LocationSettings(accuracy: LocationAccuracy.high),
      );

      locationModel.longitude = position.longitude;
      locationModel.latitude = position.latitude;
      return locationModel;
    } catch (e) {
      Log.e("Get Current Location - Helper", e.toString());
      return null;
    }
  }

  //
  static Future<Stream<Position>?> getCurrentLocationStream() async {
    try {
      bool hasPermission = await _handleLocPermission();
      if (!hasPermission) return null;

      LocationSettings? locationSettings;
      if (GetPlatform.isAndroid) {
        locationSettings = AndroidSettings(accuracy: LocationAccuracy.high);
      } else if (GetPlatform.isIOS) {
        locationSettings = AppleSettings(accuracy: LocationAccuracy.high);
      } else {
        locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
        );
      }
      Stream<Position> positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      );
      return positionStream;
    } catch (e) {
      Log.e("Error on Current Location Stream - Helper", e.toString());
      return null;
    }
  }

  static Future<String?> getIPAddress() async {
    try {
      List<NetworkInterface> networkInterfaceList =
          await NetworkInterface.list();
      for (var interface in networkInterfaceList) {
        for (var network in interface.addresses) {
          if (network.type == InternetAddressType.IPv4) {
            return network.address;
          }
        }
      }
      return null;
    } catch (e) {
      Log.e("IP Fetch Error - Helper", e.toString());
      return null;
    }
  }

  static String timeAgo(String createdAt) {
    final DateTime createdTime = DateTime.parse(createdAt).toLocal();
    final Duration diff = DateTime.now().difference(createdTime);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()}w ago';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()}mo ago';
    } else {
      return '${(diff.inDays / 365).floor()}y ago';
    }
  }

  static String getOrdinal(int number) {
    if (number <= 0) return number.toString();

    // Handle special cases 11th, 12th, 13th
    if (number % 100 >= 11 && number % 100 <= 13) {
      return "${number}th";
    }

    switch (number % 10) {
      case 1:
        return "${number}st";
      case 2:
        return "${number}nd";
      case 3:
        return "${number}rd";
      default:
        return "${number}th";
    }
  }
}
