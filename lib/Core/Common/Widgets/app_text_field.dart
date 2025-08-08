import 'package:towtrackwhiz/Core/Utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../helper.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? initialValue;
  final String hintText;
  final Widget? prefix;
  final Widget? suffix;
  final bool? enabled;
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

  const AppTextField({
    super.key,
    this.controller,
    this.label = '',
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
    this.obscureText = false, this.autoValidateMode, this.initialValue, this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
      style: Get.textTheme.bodyLarge?.copyWith(color: AppColors.darkGreyColor),
      enabled: enabled,
      decoration: InputDecoration(
        label: label.isNotEmpty ? Text(label) : null,
        hintText: hintText,
        prefixIcon: prefix,
        suffixIcon: suffix,
      ),
    );
  }
}
