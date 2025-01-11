import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import '../services/profile_picture_cache_service.dart';

class CachedProfilePicture extends StatelessWidget {
  final String email;
  final double size;
  final bool showBorder;

  const CachedProfilePicture({
    Key? key,
    required this.email,
    required this.size,
    this.showBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ProfilePictureCacheService(),
      builder: (context, _) {
        final cachedPicture = ProfilePictureCacheService().getCachedProfilePicture(email);
        
        if (cachedPicture != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: Image.memory(
              base64Decode(cachedPicture),
              height: size,
              width: size,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          );
        }
        
        return SvgPicture.asset(
          'assets/images/person.crop.circle.fill.svg',
          height: size,
          width: size,
          fit: BoxFit.contain,
        );
      },
    );
  }
} 