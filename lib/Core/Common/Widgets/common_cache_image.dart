import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/Utils/app_colors.dart';

class CommonCacheImage extends StatelessWidget {
  final String imgUrl;
  final Color? imgColor;
  final double? height;
  final double? width;
  final double? roundedCorners;
  final BoxFit? boxFit;

  const CommonCacheImage({
    super.key,
    required this.imgUrl,
    this.imgColor,
    this.height,
    this.width,
    this.roundedCorners,
    this.boxFit,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(roundedCorners ?? 0.r),
      child: CachedNetworkImage(
        imageUrl: imgUrl,
        width: width ?? 30.w,
        height: height ?? 30.w,
        color: imgColor,
        fit: boxFit ?? BoxFit.cover,
        // placeholder:
        //     (context, url) => Container(
        //       width: 30.w,
        //       height: 30.w,
        //       alignment: Alignment.center,
        //       child: const CircularProgressIndicator(
        //         strokeWidth: 2,
        //         valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        //       ),
        //     ),
        errorWidget: (context, url, error) => SizedBox.shrink(),
        // Image.network(
        // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTed7ytmvKOdAhKD4DibQ3xEuFuBozev9PjLp3a00xpu94MUrWzIcX_pideQYkSK91kydw&usqp=CAU',
        // width: 30.w,
        // height: 30.w,
        // ),
        // errorWidget: (context, url, error) => Icon(
        //   Icons.error,
        //   color: Colors.red,
        //   size: 24.w,
        // ),
      ),
    );
  }
}
