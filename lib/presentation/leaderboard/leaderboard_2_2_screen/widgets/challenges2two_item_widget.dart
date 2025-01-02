import 'package:flutter/material.dart';
import '../../../../../core/app_export.dart';
import '../models/challenges2two_item_model.dart';

// Widget that displays an individual challenge card in the challenge carousel
class Challenges2twoItemWidget extends StatelessWidget {
  Challenges2twoItemWidget(this.challenges2twoItemModelObj, {Key? key})
      : super(
          key: key,
        );

  // Model containing the challenge data to display
  final Challenges2twoItemModel challenges2twoItemModelObj;

  @override
  Widget build(BuildContext context) {
    // Card widget provides the main container with elevation and shape
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: EdgeInsets.zero,
      color: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Container(
        height: 108.h,
        decoration: AppDecoration.darkBlueContrastwithLightBlue.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder10,
        ),
        // Stack allows overlaying the challenge image and text
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Challenge image displayed at the top
            CustomImageView(
              imagePath: challenges2twoItemModelObj.vectorOne!,
              height: 78.h,
              width: 74.h,
              alignment: Alignment.topCenter,
            ),
            // Challenge title text positioned at the bottom
            Container(
              width: 62.h,
              margin: EdgeInsets.only(bottom: 8.h),
              child: Text(
                challenges2twoItemModelObj.beatlesOne!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTextStyles.bodyMedium13,
              ),
            )
          ],
        ),
      ),
    );
  }
}
