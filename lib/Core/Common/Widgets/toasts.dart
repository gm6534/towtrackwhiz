import 'package:towtrackwhiz/Core/Common/Widgets/progress_indicator.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../Utils/app_colors.dart';
import '../Dialog/confirmation_dialog.dart';
import '../Dialog/error_dialoge.dart';

class ToastAndDialog {
  static progressIndicator({RxString? text}) {
    text ??= ToastMsg.pleaseWait.obs;

    Get.dialog(ProgressDialog(text: text), barrierDismissible: false);
  }

  static Future<bool> confirmation({
    String? title,
    String? message,
    okText = ActionText.yes,
    cancelText = ActionText.no,
  }) async {
    return await Get.dialog(
      ConfirmationDialog(
        title: title,
        message: message,
        okText: okText,
        cancelText: cancelText,
      ),
      barrierDismissible: false,
    );
  }

  static Future<bool?> errorDialog(
    dynamic error, {
    Function? ok,
    String messageError = ToastMsg.unknownError,
    String title = "",
    bool authError = false,
  }) async {
    String message = messageError;
    if (error != null) {
      if (error is String) {
        message = error;
      } else if (error.message != null) {
        message = error.message;
      }
    }

    if (message == ErrorCode.connectionAbort ||
        message.contains(ErrorCode.failedHost)) {
      message = ToastMsg.unableToConnect;
    }

    if (message.contains(ErrorCode.invalidHtml)) {
      message = ToastMsg.internalServerError;
    }

    if (message == ToastMsg.internetNotAvailable) {
      return false;
    }
    return await Get.dialog(
      ErrorDialogBody(ok: ok, message: message),
      barrierDismissible: false,
    );
  }

  static void showCustomSnackBar(
    String message, {
    String? title,
    Color? backgroundColor,
    double borderRadius = 10,
    int duration = 3,
    Widget? titleWidget,
    // SnackPosition position = SnackPosition.TOP,
    ToastGravity? gravity,
    Color textColor = Colors.black,
  }) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      gravity: gravity ?? ToastGravity.TOP,
      backgroundColor: backgroundColor ?? AppColors.secondary,
    );
  }
}
