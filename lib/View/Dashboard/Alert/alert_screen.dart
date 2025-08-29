import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:towtrackwhiz/Core/Constants/app_strings.dart';

import '../../Common/alert_card_widget.dart';

class AlertScreen extends StatelessWidget {
  const AlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15.w,
      children: [
        Text(AppHeadings.communityAlerts, style: Get.textTheme.displaySmall),
        Expanded(
          child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return AlertCardWidget();
            },
          ),
        ),
      ],
    );
  }
}
