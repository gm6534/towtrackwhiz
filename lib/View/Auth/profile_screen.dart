import 'dart:io';

import 'package:towtrackwhiz/Controller/Auth/profile_controller.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/app_text_field.dart';
import 'package:towtrackwhiz/Core/Common/Widgets/base_scaffold.dart';
import 'package:towtrackwhiz/Core/Common/validation_helper.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Core/Common/Widgets/app_button.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBarTitle: "profile".tr,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Obx(() {
            if (controller.isProfileLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            final user = controller.currentUser.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 16.w,
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
                AppTextField(
                  label: "email".tr,
                  initialValue: user.email ?? '',
                  enabled: false,
                ),
                AppTextField(
                  label: "name".tr,
                  initialValue: user.name ?? '',
                  onChanged: (value) => controller.updateField(name: value),
                ),

                AppTextField(
                  label: "phone".tr,
                  initialValue: user.phone ?? '',
                  textInputType: TextInputType.phone,
                  onChanged: (value) => controller.updateField(phone: value),
                ),
                AppTextField(
                  label: "password".tr,
                  controller: controller.passwordC,
                  textInputType: TextInputType.phone,
                  onChanged: (value) => controller.checkChanges(),
                  // validator:
                  //     (password) => ValidationHelper.validatePassword(password),
                ),
                AppTextField(
                  label: "confirm_password".tr,
                  controller: controller.confirmPasswordC,
                  textInputType: TextInputType.phone,
                  onChanged: (value) => controller.checkChanges(),
                  // validator:
                  //     (confirmPassword) =>
                  //         ValidationHelper.validateConfirmPassword(
                  //           controller.passwordC.text,
                  //           confirmPassword,
                  //         ),
                ),

                // AppTextField(
                //   label: "role".tr,
                //   initialValue: user.role ?? '',
                //   enabled: false,
                //   onChanged: (value) => controller.updateField(role: value),
                // ),
                // SizedBox(height: 16.h),
                //
                // AppTextField(
                //   label: "status".tr,
                //   initialValue: user.status ?? '',
                //   enabled: false,
                //   onChanged: (value) => controller.updateField(status: value),
                // ),
                // SizedBox(height: 16.h),
                //
                // AppTextField(
                //   label: "availability".tr,
                //   initialValue: user.availability ?? '',
                //   enabled: false,
                //   onChanged:
                //       (value) => controller.updateField(availability: value),
                // ),
                SizedBox(height: 30.h),

                Obx(
                  () => AppButton(
                    title: "update".tr,
                    onPressed:
                        !controller.isChanged.value
                            ? null
                            : () async {
                              await controller.updateUserProfile();
                            },
                  ),
                ),
              ],
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
            Text("choose_image".tr, style: TextStyle(fontSize: 16.sp)),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("camera".tr),
              onTap: () {
                Get.back();
                controller.pickImageFromSource(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text("gallery".tr),
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
