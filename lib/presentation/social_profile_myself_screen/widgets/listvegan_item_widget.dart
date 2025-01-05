import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_export.dart';
import '../models/listvegan_item_model.dart';
import '../provider/social_profile_myself_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListveganItemWidget extends StatelessWidget {
  final ListveganItemModel model;

  const ListveganItemWidget(this.model, {Key? key}) : super(key: key);

  String _calculateTimeDifference(String createdDate) {
    try {
      final parts = createdDate.split('/');
      
      if (parts.length != 3) {
        return "some time";
      }

      final createdDateTime = DateTime(
        int.parse(parts[2]), // year
        int.parse(parts[1]), // month
        int.parse(parts[0]), // day
      );
      
      final now = DateTime.now();
      final difference = now.difference(createdDateTime);
      final days = difference.inDays;
      
      // Calculate years more accurately by checking actual days
      final years = days ~/ 365;
      // Calculate remaining days after years
      final remainingDays = days % 365;
      // Calculate months from remaining days
      final months = remainingDays ~/ 30;
      
      if (days >= 365) {
        return "$years year${years > 1 ? 's' : ''}";
      } else if (days >= 30) {
        final adjustedMonths = (days / 30.44).floor(); // Average days in a month
        return "$adjustedMonths month${adjustedMonths > 1 ? 's' : ''}";
      } else {
        return "$days day${days > 1 ? 's' : ''}";
      }
    } catch (e) {
      return "some time";
    }
  }

  @override
  Widget build(BuildContext context) {
    String? dietText = model.title;
    Color boxColor;

    if (dietText?.contains("been thriving") == true || dietText?.contains("'s been thriving") == true || dietText?.contains("thriving") == true) {
      boxColor = const Color(0xFFFFD700); // Yellow for user's message
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where(model.username?.contains('@') == true ? 'email' : 'username', isEqualTo: model.username)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildContainer(context, "Loading...", const Color(0xFFFFD700));
          }

          if (snapshot.hasError) {
            return _buildContainer(context, "Error loading data", const Color(0xFFFFD700));
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final userData = snapshot.data!.docs.first.data();
            final firstName = userData['firstName']?.toString() ?? '';
            final createdDate = userData['create']?.toString();
            
            if (createdDate != null && createdDate.isNotEmpty) {
              final timeDifference = _calculateTimeDifference(createdDate);
              if (!dietText!.contains(firstName)) {
                dietText = "$firstName has been thriving with us for $timeDifference! ⭐️";
              }
            } else {
              if (!dietText!.contains(firstName)) {
                dietText = "$firstName has been thriving with us! ⭐️";
              }
            }
          } else {
            dietText = "Loading...";
          }
          return _buildContainer(context, dietText ?? "", const Color(0xFFFFD700));
        },
      );
    } else {
      switch (dietText) {
        case 'Vegan🌱':
          boxColor = const Color(0xFF4CAF50); // Green
          break;
        case 'Carnivore🥩':
          boxColor = const Color(0xFFB84C4C); // Red
          break;
        case 'Vegetarian🥗':
          boxColor = const Color(0xFF8BC34A); // Light Green
          break;
        case 'Pescatarian🐟':
          boxColor = const Color(0xFF03A9F4); // Light Blue
          break;
        case 'Keto🥑':
          boxColor = const Color(0xFF9C27B0); // Purple
          break;
        case 'Fruitarian🍎':
          boxColor = const Color(0xFFFF9800); // Orange
          break;
        default:
          boxColor = const Color(0xFFFFD700); // Yellow for default/unknown diet
      }
      return _buildContainer(context, dietText ?? "", boxColor);
    }
  }

  Widget _buildContainer(BuildContext context, String text, Color color) {
    // Check if this is a diet box with emoji or thriving box with star
    bool hasDietEmoji = text.contains('🌱') || text.contains('🥩') || 
                       text.contains('🥗') || text.contains('🐟') || 
                       text.contains('🥑') || text.contains('🍎');
    bool hasStarEmoji = text.contains('⭐️');
    bool hasEmoji = hasDietEmoji || hasStarEmoji;
    
    // Split text into text and emoji
    String displayText = text;
    String? emoji;
    if (hasDietEmoji) {
      displayText = text.substring(0, text.length - 2); // Remove emoji from text
      emoji = text.substring(text.length - 2); // Get emoji
    } else if (hasStarEmoji) {
      displayText = text.substring(0, text.length - 3); // Remove star emoji (it's 3 characters)
      emoji = text.substring(text.length - 3); // Get star emoji
    }

    return Container(
      width: 160.h,
      height: 100.h,
      padding: EdgeInsets.symmetric(
        horizontal: 10.h,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(21),
      ),
      child: Center(
        child: hasEmoji
          ? RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: displayText,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                    ),
                  ),
                  TextSpan(
                    text: emoji,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                      shadows: [
                        Shadow(
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Text(
              text,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
      ),
    );
  }
}