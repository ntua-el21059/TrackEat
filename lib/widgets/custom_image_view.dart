import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (this.startsWith('http') || this.startsWith('https')) {
      return ImageType.network;
    } else if (this.endsWith('.svg')) {
      return ImageType.svg;
    } else if (this.startsWith('file://')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file, unknown }

class CustomImageView extends StatelessWidget {
  final String? imagePath;
  final bool isFile;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final String placeHolder;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;

  const CustomImageView({
    this.imagePath,
    this.isFile = false,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'assets/images/image_not_found.png',
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath == null) return SizedBox();

    return isFile
        ? ClipRRect(
            borderRadius: radius ?? BorderRadius.zero,
            child: Image.file(
              File(imagePath!),
              height: height,
              width: width,
              fit: fit ?? BoxFit.contain,
              alignment: alignment ?? Alignment.center,
            ),
          )
        : _buildDefaultImage();
  }

  Widget _buildDefaultImage() {
    if (imagePath == null) return SizedBox();
    
    return imagePath!.endsWith('.svg')
        ? SvgPicture.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.contain,
            alignment: alignment ?? Alignment.center,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
          )
        : Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.contain,
            alignment: alignment ?? Alignment.center,
            color: color,
          );
  }
}