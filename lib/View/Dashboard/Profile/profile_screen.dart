import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:towtrackwhiz/Controller/Dashboard/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  ProfileController controller = Get.find<ProfileController>();
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 30.r, backgroundColor: Colors.grey.shade300),
              10.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Leo Jenna",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text("leo34@gmail.com"),
                ],
              ),
            ],
          ),
          20.verticalSpace,
          ListTile(
            title: const Text("My Vehicles"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: const Text("Notification Settings"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: const Text("Account Settings"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: const Text("Payout Method"),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: const Text("Logout"),
            trailing: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
