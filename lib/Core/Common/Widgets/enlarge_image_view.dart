import 'package:flutter/material.dart';
import 'package:towtrackwhiz/Core/Utils/app_colors.dart';

class EnlargeImageView extends StatelessWidget {
  final String? path;
  final String? title;

  const EnlargeImageView({super.key, this.path, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(title ?? "Image"),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          panEnabled: true,
          minScale: 1.0,
          maxScale: 10.0,
          child: Image.network(path!, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
