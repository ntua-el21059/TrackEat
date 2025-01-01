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
      return _buildDefaultImage();
    }

    Widget imageWidget;

    if (isFile) {
      try {
        imageWidget = Image.file(
          File(imagePath!),
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
          errorBuilder: (context, error, stackTrace) => _buildDefaultImage(),
        );
      } catch (e) {
        imageWidget = _buildDefaultImage();
      }
    } else if (imagePath!.startsWith('http')) {
      imageWidget = CachedNetworkImage(
        imageUrl: imagePath!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
        placeholder: (context, url) => _buildDefaultImage(),
        errorWidget: (context, url, error) => _buildDefaultImage(),
      );
    } else {
      try {
        if (imagePath!.endsWith('.svg')) {
          imageWidget = SvgPicture.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
          );
        } else {
          imageWidget = Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            errorBuilder: (context, error, stackTrace) => _buildDefaultImage(),
          );
        }
      } catch (e) {
        imageWidget = _buildDefaultImage();
      }
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

  Widget _buildDefaultImage() {
    return Image.asset(
      'assets/images/imgVector80x84.png',
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      color: color,
    );
  }
}