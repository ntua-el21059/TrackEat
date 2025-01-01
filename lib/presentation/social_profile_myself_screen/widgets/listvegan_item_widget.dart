import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_export.dart';
import '../models/listvegan_item_model.dart';
import '../provider/social_profile_myself_provider.dart';

class ListveganItemWidget extends StatelessWidget {
  final ListveganItemModel model;

  const ListveganItemWidget(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SocialProfileMyselfProvider>(
      builder: (context, provider, _) {
        String? dietText = model.title;
        Color boxColor;

        // Determine box color based on diet
        if (dietText?.contains("Tim's been thriving") == true) {
          boxColor = const Color(0xFFFFD700); // Yellow for Tim's message
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
        }

        return Container(
          width: 160.h,
          height: 91.h,
          padding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(21),
          ),
          child: Center(
            child: Text(
              model.title ?? "",
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
          ),
        );
      },
    );
  }
}