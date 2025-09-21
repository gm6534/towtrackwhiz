import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/core/Constants/app_strings.dart';

import 'Controller/Other/connectivity_controller.dart';
import 'Core/Notify/notification_service.dart';
import 'app_config.dart';
import 'core/Routes/app_pages.dart';
import 'core/Routes/app_route.dart';
import 'core/Theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppConfig.initialize();
  Get.find<ConnectionManagerController>();
  // Get.put(SchedulerController());
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
  NotificationService().init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder:
          (_, child) => GetMaterialApp(
            navigatorKey: Get.key,
            title: AppInfo.appTitle,
            getPages: AppPages.pages,
            initialRoute: AppRoute.initial,
            debugShowCheckedModeBanner: false,
            scrollBehavior: ScrollConfiguration.of(context).copyWith(
              overscroll: false,
              physics: const BouncingScrollPhysics(),
            ),
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.light,
          ),
    );
  }
}
