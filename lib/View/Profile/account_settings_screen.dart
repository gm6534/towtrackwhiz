import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';

import '../../Controller/Dashboard/profile_controller.dart';
import '../../Core/Common/Widgets/app_button.dart';
import '../../Core/Common/Widgets/app_heading_text_field.dart';
import '../../Core/Common/Widgets/base_scaffold.dart';
import '../../Core/Common/validation_helper.dart';
import '../../core/Utils/app_colors.dart';

class AccountSettingsScreen extends GetView<ProfileController> {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBarTitle: AppHeadings.accountSettings,
      body: Center(
        child: SingleChildScrollView(
          child: Obx(() {
            if (controller.isProfileLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            final user = controller.currentUser.value;

            return Form(
              key: controller.profileFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10.w,
                children: [
                  GestureDetector(
                    onTap: () => _showAvatarPicker(context),
                    child: Container(
                      height: 130.w,
                      width: 130.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.greyColor,
                        image:
                            user.avatar != null
                                ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      user.avatar!.startsWith("http")
                                          ? NetworkImage(user.avatar!)
                                          : FileImage(File(user.avatar!))
                                              as ImageProvider,
                                )
                                : null,
                      ),
                      child:
                          user.avatar == null
                              ? Icon(
                                Icons.camera_alt,
                                size: 40.w,
                                color: Colors.white,
                              )
                              : null,
                    ),
                  ),
                  AppHeadingTextField(
                    heading: AppHeadings.email,
                    initialValue: user.email ?? '',
                    enabled: false,
                    prefix: Container(
                      margin: EdgeInsets.all(15.w),
                      child: Image.asset(
                        ImgPath.msgIcon,
                        height: 10.w,
                        width: 10.w,
                      ),
                    ),
                  ),
                  AppHeadingTextField(
                    heading: AppHeadings.name,
                    initialValue: user.name ?? '',
                    onChanged: (value) => controller.updateField(name: value),
                    prefix: Icon(Icons.person, color: AppColors.primary),
                    validator: (name) => ValidationHelper.validateName(name, AppHeadings.name),
                  ),
                  AppHeadingTextField(
                    heading: AppHeadings.password,
                    controller: controller.passwordC,
                    textInputType: TextInputType.visiblePassword,
                    onChanged: (value) => controller.checkChanges(),
                    prefix: Container(
                      margin: EdgeInsets.all(15.w),
                      child: Image.asset(
                        ImgPath.passIcon,
                        height: 10.w,
                        width: 10.w,
                      ),
                    ),
                    // validator:
                    //     (password) => ValidationHelper.validatePassword(password),
                  ),
                  AppHeadingTextField(
                    heading: AppHeadings.confirmPassword,
                    controller: controller.confirmPasswordC,
                    textInputType: TextInputType.visiblePassword,
                    onChanged: (value) => controller.checkChanges(),
                    prefix: Container(
                      margin: EdgeInsets.all(15.w),
                      child: Image.asset(
                        ImgPath.passIcon,
                        height: 10.w,
                        width: 10.w,
                      ),
                    ),
                    // validator:
                    //     (confirmPassword) =>
                    //         ValidationHelper.validateConfirmPassword(
                    //           controller.passwordC.text,
                    //           confirmPassword,
                    //         ),
                  ),
                  SizedBox(height: 30.h),

                  Obx(
                    () => AppButton(
                      title: ActionText.update,
                      onPressed:
                          !controller.isChanged.value
                              ? null
                              : () async {
                                await controller.updateUserProfile();
                              },
                    ),
                  ),
                  15.verticalSpace,
                  AppButton(
                    title: ActionText.delete,
                    btnColor: AppColors.redColor,
                    onPressed: controller.deleteUserProfile,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  void _showAvatarPicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(Strings.chooseImg, style: TextStyle(fontSize: 16.sp)),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text(Strings.camera),
              onTap: () {
                Get.back();
                controller.pickImageFromSource(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text(Strings.gallery),
              onTap: () {
                Get.back();
                controller.pickImageFromSource(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
