import 'package:flutter/services.dart';
import 'package:towtrackwhiz/Controller/Other/connectivity_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/no_internet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/Utils/app_colors.dart';

class BaseScaffold extends StatelessWidget {
  final String appBarTitle;
  final bool centerTitle;
  final AppBar? appBar;
  final Widget body;
  final EdgeInsets? bodyPadding;
  final Widget? drawer;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  BaseScaffold({
    super.key,
    this.appBarTitle = '',
    this.centerTitle = true,
    required this.body,
    this.actions,
    this.drawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.appBar,
    this.bodyPadding,
  });

  final ConnectionManagerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.scaffoldBgColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          drawer: drawer,
          appBar:
              appBar ??
              (appBarTitle.isNotEmpty
                  ? AppBar(
                    title: Text(appBarTitle),
                    centerTitle: centerTitle,
                    actionsPadding: EdgeInsets.symmetric(horizontal: 20.w),
                    actions: actions,
                  )
                  : null),
          body: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: bodyPadding ?? EdgeInsets.all(16.w),
                    child: body,
                  ),
                ),
                if (!controller.isConnected.value) NoInternetWidget(),
              ],
            );
          }),
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );
  }
}
