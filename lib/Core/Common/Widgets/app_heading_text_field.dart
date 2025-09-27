import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../helper.dart';

class AppHeadingTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String heading;
  final String? initialValue;
  final String hintText;
  final Widget? prefix;
  final Widget? suffix;
  final bool? enabled;
  final bool? filled;
  final Color? fillColor;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final ScrollController? scrollController;
  final FocusNode? focusNode;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focus;
  final Function()? onTap;
  final Function(String)? onChanged;
  final bool readOnly;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool obscureText;
  final AutovalidateMode? autoValidateMode;
  final EdgeInsetsGeometry? contentPadding;

  const AppHeadingTextField({
    super.key,
    this.controller,
    required this.heading,
    this.hintText = '',
    this.prefix,
    this.suffix,
    this.textInputType,
    this.scrollController,
    this.focusNode,
    this.maxLines = 1,
    this.inputFormatters,
    this.focus,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.onSaved,
    this.validator,
    this.textInputAction,
    this.obscureText = false,
    this.autoValidateMode,
    this.initialValue,
    this.enabled,
    this.filled,
    this.fillColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 10.w,
      children: [
        Text(heading, style: Get.textTheme.titleLarge),
        TextFormField(
          initialValue: initialValue,
          controller: controller,
          scrollController: scrollController,
          focusNode: focusNode,
          onTapOutside: (event) {
            Helper.unFocusScope();
          },
          obscureText: obscureText,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          onSaved: onSaved,
          cursorColor: AppColors.primary,
          validator: validator,
          autovalidateMode: autoValidateMode,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          keyboardType: textInputType,
          textInputAction: textInputAction ?? TextInputAction.next,
          style: Get.textTheme.bodyLarge?.copyWith(
            color: AppColors.darkGreyColor,
          ),
          enabled: enabled,
          decoration: InputDecoration(
            contentPadding: contentPadding,
            filled: filled,
            fillColor: fillColor,
            // label: heading.isNotEmpty ? Text(heading) : null,
            hintText: hintText,
            hintStyle: Get.textTheme.bodyLarge?.copyWith(
              color: AppColors.lightGreyColor,
            ),
            prefixIcon: prefix,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
