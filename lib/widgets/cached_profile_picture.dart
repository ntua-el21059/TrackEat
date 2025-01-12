import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import '../services/profile_picture_cache_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    // Get cached picture immediately
    final cachedPicture = ProfilePictureCacheService().getCachedProfilePicture(email);
    
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .snapshots(),
      builder: (context, snapshot) {
        // Use cached version if available and no new data
        if (cachedPicture != null && (!snapshot.hasData || !snapshot.data!.exists)) {
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

        // Use Firestore data if available
        if (snapshot.hasData && snapshot.data!.exists) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final profilePicture = userData['profilePicture'] as String?;

          if (profilePicture != null && profilePicture.isNotEmpty) {
            // Update cache in background
            ProfilePictureCacheService().getOrUpdateCache(email, profilePicture);
            
            return ClipRRect(
              borderRadius: BorderRadius.circular(size / 2),
              child: Image.memory(
                base64Decode(profilePicture),
                height: size,
                width: size,
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
            );
          }
        }
        
        // Show default picture if no data available
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