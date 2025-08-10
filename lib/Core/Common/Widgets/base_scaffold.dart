import 'package:towtrackwhiz/Controller/Other/connectivity_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/no_internet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BaseScaffold extends StatelessWidget {
  final String appBarTitle;
  final bool centerTitle;
  final Widget body;
  final Widget? drawer;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final BottomNavigationBar? bottomNavigationBar;
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
  });

  final ConnectionManagerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      appBar:
          appBarTitle.isNotEmpty
              ? AppBar(
                title: Text(appBarTitle),
                centerTitle: centerTitle,
                actionsPadding: EdgeInsets.symmetric(horizontal: 20.w),
                actions: actions,
              )
              : null,
      body: SafeArea(
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(padding: EdgeInsets.all(16.w), child: body),
              ),
              if (!controller.isConnected.value) NoInternetWidget(),
            ],
          );
        }),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
