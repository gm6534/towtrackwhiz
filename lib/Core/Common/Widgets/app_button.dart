import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Controller/Other/connectivity_controller.dart';

class AppButton extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  final double? height;
  final double? width;
  final double? cornerRadius;
  final bool isOutlined;
  final Color? btnColor;

  AppButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.height,
    this.width,
    this.cornerRadius,
    this.isOutlined = false,
    this.btnColor,
  });

  final ConnectionManagerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: height ?? 50.w,
        width: width ?? Get.width,
        child:
            isOutlined
                ? OutlinedButton(
                  onPressed: controller.isConnected.value ? onPressed : null,
                  style: Get.theme.outlinedButtonTheme.style?.copyWith(
                    side: WidgetStatePropertyAll(
                      btnColor != null
                          ? BorderSide(color: btnColor!)
                          : BorderSide.none,
                    ),
                    foregroundColor: WidgetStatePropertyAll(btnColor),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          cornerRadius ?? 10.r,
                        ),
                      ),
                    ),
                  ),
                  child: FittedBox(child: Text(title)),
                )
                : ElevatedButton(
                  onPressed: controller.isConnected.value ? onPressed : null,
                  style: Get.theme.elevatedButtonTheme.style?.copyWith(
                    backgroundColor: WidgetStatePropertyAll(btnColor),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          cornerRadius ?? 10.r,
                        ),
                      ),
                    ),
                  ),
                  child: FittedBox(child: Text(title)),
                ),
      );
    });
  }
}
