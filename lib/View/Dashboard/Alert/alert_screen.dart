import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertScreen extends StatelessWidget {
  const AlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Community Alerts",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          20.verticalSpace,
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
      ),
    );
  }
}
