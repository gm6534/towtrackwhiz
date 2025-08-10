import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportTowActivity extends StatelessWidget {
  const ReportTowActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Report Tow Activity",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            10.verticalSpace,
            DropdownButtonFormField(
              items: ["Tow truck seen", "Car being towed", "Tow signage posted"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {},
              decoration: const InputDecoration(labelText: "Select Type"),
            ),
            10.verticalSpace,
            TextFormField(decoration: const InputDecoration(labelText: "Location")),
            10.verticalSpace,
            TextFormField(decoration: const InputDecoration(labelText: "Comments (Optional)")),
            10.verticalSpace,
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48.h)),
              onPressed: () {},
              child: const Text("Submit Report"),
            ),
          ],
        ),
      ),
    );
  }
}

