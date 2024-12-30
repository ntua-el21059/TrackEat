import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomImageView extends StatelessWidget {
  final String? imagePath;
  final bool isFile;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final Alignment? alignment;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;
  final VoidCallback? onTap;
  final String placeHolder;

  const CustomImageView({
    Key? key,
    this.imagePath,
    this.isFile = false,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.margin,
    this.radius,
    this.border,
    this.onTap,
    this.placeHolder = 'assets/images/image_not_found.png',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return margin != null
        ? Padding(
            padding: margin!,
            child: _buildWidget(),
          )
        : _buildWidget();
  }

  Widget _buildWidget() {
    if (imagePath == null || imagePath!.isEmpty) {
      return const SizedBox();
    }

    Widget imageWidget;

    if (isFile) {
      imageWidget = Image.file(
        File(imagePath!),
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
        color: color,
      );
    } else if (imagePath!.endsWith('.svg')) {
      imageWidget = SvgPicture.asset(
        imagePath!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
        color: color,
        allowDrawingOutsideViewBox: true,
        clipBehavior: Clip.none,
      );
    } else if (imagePath!.startsWith('http') || imagePath!.startsWith('https')) {
      imageWidget = CachedNetworkImage(
        imageUrl: imagePath!,
        height: height,
        width: width,
        fit: fit,
        color: color,
        alignment: alignment ?? Alignment.center,
      );
    } else {
      imageWidget = Image.asset(
        imagePath!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.contain,
        alignment: alignment ?? Alignment.center,
        color: color,
      );
    }

    if (radius != null || border != null) {
      imageWidget = Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: border,
        ),
        child: ClipRRect(
          borderRadius: radius ?? BorderRadius.zero,
          child: imageWidget,
        ),
      );
    }

    if (onTap != null) {
      imageWidget = GestureDetector(
        onTap: onTap,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}