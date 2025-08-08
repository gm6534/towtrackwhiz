
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/Constants/app_strings.dart';
import '../../../core/Utils/app_colors.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    this.title,
    this.message,
    this.okText,
    this.cancelText,
  });

  final String? title;
  final String? message;
  final String? okText;
  final String? cancelText;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {},
      child: CupertinoAlertDialog(
        title:
            title != null
                ? Text(
                  title!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                )
                : Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(
                    ImgPath.appLogo,
                    height: 70.w,
                    width: 70.w,
                  ),
                ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "$message",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            style: TextButton.styleFrom(shape: RoundedRectangleBorder()),
            child: Text(
              cancelText!,
              style: Get.textTheme.headlineSmall?.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            style: TextButton.styleFrom(shape: RoundedRectangleBorder()),
            child: Text(
              okText!,
              style: Get.textTheme.headlineSmall?.copyWith(
                color: AppColors.redColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
