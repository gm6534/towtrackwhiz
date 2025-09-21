import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:towtrackwhiz/Core/Common/helper.dart';

import '../../Core/Constants/app_strings.dart';
import '../../Core/Utils/log_util.dart';
import '../../Model/Auth/auth_response_model.dart';

@pragma('vm:entry-point')
Future<void> locationCallbackTopLevel() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await GetStorage.init();
    final pos =
        SchedulerController.positionStreamIos ??
        await Geolocator.getCurrentPosition();

    if (SchedulerController.positionStreamIos != null) {
      Log.d(
        "Position Stream Ios",
        "📍 ${SchedulerController.positionStreamIos?.latitude}",
      );
    }

    final storage = GetStorage();
    final authData = storage.read(GetStorageKeys.authInfo);

    if (authData != null) {
      final authInfo = AuthResponseModel.fromJson(authData);

      if (authInfo.user?.id != null) {
        var response = await http.post(
          Uri.parse("https://towtrack.devdioxide.com/api/location"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${authInfo.token}',
          },
          body: json.encode({
            "user_id": authInfo.user?.id,
            "latitude": pos.latitude,
            "longitude": pos.longitude,
          }),
        );

        Map<String, dynamic> responseData = json.decode(response.body);
        String message = responseData['message'];

        if (response.statusCode == 200) {
          Log.d("📍 Updated location", message);
        } else {
          throw http.ClientException(message);
        }
      }
    }
  } catch (e) {
    Log.e("Location", "❌ Error updating location: $e");
  }
}

class SchedulerController extends GetxController with WidgetsBindingObserver {
  Timer? _foregroundTimer;
  StreamSubscription<Position>? _iosBackgroundStream;
  static Position? positionStreamIos;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _startForegroundUpdates(); // start immediately when app is open
    _initializeBackgroundManagers();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopForegroundUpdates();
    _stopiOSBackgroundUpdates();
    super.onClose();
  }

  /// 🔹 Lifecycle handler
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App in foreground
      _startForegroundUpdates();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // App in background
      _stopForegroundUpdates();

      if (Platform.isIOS) {
        _startiOSBackgroundUpdates();
      }
    }
  }

  /// 🔹 Init AlarmManager (Android) and setup
  Future<void> _initializeBackgroundManagers() async {
    // // ✅ Check before requesting
    // final current = await Permission.scheduleExactAlarm.status;
    // if (current.isDenied || current.isRestricted) {
    //   final permission = await Permission.scheduleExactAlarm.request();
    //   if (!permission.isGranted) {
    //     Log.d("Android Alarm Manager", "❌ Alarm permission not granted");
    //     return;
    //   }
    // }
    if (Platform.isAndroid) {
      // await AndroidAlarmManager.cancel(1);
      await AndroidAlarmManager.initialize();
      bool res = await AndroidAlarmManager.periodic(
        const Duration(minutes: 1),
        1,
        locationCallbackTopLevel,
        wakeup: true,
        rescheduleOnReboot: true,
        allowWhileIdle: true,
      );
      Log.d("Android Alarm Manager", "▶️ Background Services Started = $res");
    }
  }

  /// 🔹 Foreground periodic location updates (every 60s)
  void _startForegroundUpdates() {
    _foregroundTimer?.cancel();
    _foregroundTimer = Timer.periodic(const Duration(seconds: 60), (_) async {
      await locationCallbackTopLevel();
    });
    Log.d("Location", "▶️ Foreground updates started");
  }

  void _stopForegroundUpdates() {
    _foregroundTimer?.cancel();
    Log.d("Location", "⏹️ Foreground updates stopped");
  }

  /// 🔹 iOS continuous background location (Core Location stream)
  Future<void> _startiOSBackgroundUpdates() async {
    // LocationPermission permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied ||
    //     permission == LocationPermission.deniedForever) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission != LocationPermission.always &&
    //       permission != LocationPermission.whileInUse) {
    //     return;
    //   }
    // }

    _iosBackgroundStream?.cancel();
    Stream<Position>? positionStream = await Helper.getCurrentLocationStream();
    // _iosBackgroundStream = Geolocator.getPositionStream(
    //   locationSettings: const LocationSettings(
    //     accuracy: LocationAccuracy.best,
    //     distanceFilter: 10, // update every 10 meters
    //   ),
    // )
    _iosBackgroundStream = positionStream?.listen((position) async {
      positionStreamIos = position;
      await locationCallbackTopLevel();
    });

    Log.d("Location", "▶️ iOS background location stream started");
  }

  void _stopiOSBackgroundUpdates() {
    _iosBackgroundStream?.cancel();
    Log.d("Location", "⏹️ iOS background location stream stopped");
  }

  // /// 🔹 Shared location callback
  // @pragma('vm:entry-point')
  // static Future<void> locationCallback({Position? position}) async {
  //   try {
  //     final pos = position ?? await Geolocator.getCurrentPosition();
  //
  //     final storage = GetStorage();
  //     final json = storage.read(GetStorageKeys.authInfo);
  //
  //     if (json != null) {
  //       final authInfo = AuthResponseModel.fromJson(json);
  //
  //       if (authInfo.user?.id != null) {
  //         final dashboardRepo = DashboardRepo();
  //         await dashboardRepo.updateCurrentLocation(
  //           userId: authInfo.user?.id,
  //           latitude: pos.latitude,
  //           longitude: pos.longitude,
  //         );
  //
  //         Log.d("Location", "📍 Updated location");
  //       }
  //     }
  //   } catch (e) {
  //     Log.d("Location", "❌ Error updating location: $e");
  //   }
  // }
}
