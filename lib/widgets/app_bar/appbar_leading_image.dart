import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';

class AppbarLeadingImage extends StatelessWidget {
  AppbarLeadingImage({
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
  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: imagePath?.endsWith('.svg') == true
            ? SvgPicture.asset(
                imagePath!,
                height: height ?? 22.h,
                width: width ?? 16.h,
                fit: BoxFit.contain,
              )
            : Image.asset(
                imagePath!,
                height: height ?? 22.h,
                width: width ?? 16.h,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}