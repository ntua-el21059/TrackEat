import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class AppbarTrailingImage extends StatelessWidget {
  AppbarTrailingImage({
    Key? key,
    this.imagePath,
    this.margin,
    this.height,
    this.width,
    this.onTap,
  }) : super(key: key);

  String? imagePath;
  EdgeInsetsGeometry? margin;
  double? height;
  double? width;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomImageView(
          imagePath: imagePath,
          height: height,
          width: width,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}