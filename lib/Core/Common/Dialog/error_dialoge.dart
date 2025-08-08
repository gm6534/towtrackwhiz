import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/app_colors.dart';

class ErrorDialogBody extends StatelessWidget {
  final Function? ok;
  final String? message;

  const ErrorDialogBody({super.key, this.ok, this.message});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {},
      child: CupertinoAlertDialog(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            "Error",
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          // child: Image.asset(ImgPath.appLogo, height: 40.w),
        ),
        content: Text(
          message!,
          style: const TextStyle(fontSize: 13),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              side: const BorderSide(style: BorderStyle.none),
            ),
            onPressed: () async {
              Get.back(result: true);
              if (ok != null) {
                ok!.call();
              }
            },
            child: Text('Ok', style: TextStyle(color: AppColors.darkGreyColor)),
          ),
        ],
      ),
    );
  }
}
