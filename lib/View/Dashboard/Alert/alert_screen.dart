import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AlertScreen extends StatelessWidget {
  const AlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15.w,
      children: [
        Text("Community Alerts", style: Get.textTheme.displaySmall),
        Expanded(
          child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.only(bottom: 12.h),
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.red),
                  title: const Text("Gas Leak Reported"),
                  subtitle: const Text("Location X - 22min ago"),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
