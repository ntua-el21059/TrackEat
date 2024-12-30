import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/challenges1two_item_model.dart';

// ignore_for_file: must_be_immutable
class Challenges1twoItemWidget extends StatelessWidget {
  Challenges1twoItemWidget(
    this.challenges1twoItemModelObj, {
    Key? key,
  }) : super(
          key: key,
        );

  Challenges1twoItemModel challenges1twoItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: EdgeInsets.zero,
      color: appTheme.green500,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Container(
        height: 108.h,
        padding: EdgeInsets.symmetric(horizontal: 10.h),
        decoration: AppDecoration.greenavocadochallenge.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder10,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CustomImageView(
              imagePath: challenges1twoItemModelObj.vectorOne!,
              height: 76.h,
              width: double.maxFinite,
              alignment: Alignment.topCenter,
            ),
            Padding(
              padding: EdgeInsets.only(
                right: 10.h,
                bottom: 4.h,
              ),
              child: Text(
                challenges1twoItemModelObj.avocadoOne!,
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
