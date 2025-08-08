import 'package:towtrackwhiz/Controller/Other/connectivity_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppButton extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  final double? height;
  final double? width;
  final double? cornerRadius;

  AppButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.height,
    this.width,
    this.cornerRadius,
  });

  final ConnectionManagerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: height ?? 50.w,
        width: width ?? Get.width,
        child: ElevatedButton(
          onPressed: controller.isConnected.value ? onPressed : null,
          style: Get.theme.elevatedButtonTheme.style?.copyWith(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(cornerRadius ?? 40.r),
              ),
            ),
          ),
          child: FittedBox(child: Text(title)),
        ),
      );
    });
  }
}
