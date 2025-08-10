// import 'package:towtrackwhiz/Controller/dashboard_controller.dart';
// import 'package:towtrackwhiz/Core/Common/Widgets/locale_switcher.dart';
// import 'package:towtrackwhiz/Core/Utils/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// class AppDrawer extends GetView<DashboardController> {
//   const AppDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           GestureDetector(
//             onTap: controller.navigateToProfile,
//             child: DrawerHeader(
//               decoration: BoxDecoration(
//                 color: AppColors.primary,
//                 image: DecorationImage(
//                   fit: BoxFit.cover,
//                   opacity: 0.3,
//                   image: NetworkImage(controller.authController!.profileImage),
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 spacing: 4.w,
//                 children: [
//                   Container(
//                     height: 80.w,
//                     width: 80.w,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: AppColors.greyColor,
//                       image: DecorationImage(
//                         fit: BoxFit.contain,
//                         image: NetworkImage(
//                           controller.authController!.profileImage,
//                         ),
//                       ),
//                     ),
//                     child:
//                         controller.authController?.profileImage == null
//                             ? Icon(
//                               Icons.person,
//                               color: Colors.white,
//                               size: 40.w,
//                             )
//                             : null,
//                   ),
//                   Text(
//                     'Hello, ${controller.authController?.fullName}',
//                     style: Get.textTheme.headlineSmall?.copyWith(
//                       color: Colors.white,
//                     ),
//                   ),
//                   Text(
//                     '${controller.authController?.email}',
//                     style: Get.textTheme.bodySmall?.copyWith(
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.home, size: 24.sp),
//             title: Text('home'.tr, style: TextStyle(fontSize: 16.sp)),
//             onTap: () {
//               Get.back();
//             },
//           ),

//           Spacer(),
//           ListTile(
//             textColor: AppColors.redColor,
//             iconColor: AppColors.redColor,
//             leading: Icon(Icons.logout, size: 24.sp),
//             title: Text('logout'.tr, style: TextStyle(fontSize: 16.sp)),
//             onTap: controller.authController?.logout,
//           ),
//         ],
//       ),
//     );
//   }
// }
