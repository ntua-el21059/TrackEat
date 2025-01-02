import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/listfour_item_model.dart';

// ignore_for_file: must_be_immutable

// This widget represents a single item in a list, typically used for displaying
// user-related information like scores, rankings, or player stats in a game-like interface
class ListfourItemWidget extends StatelessWidget {
  ListfourItemWidget(this.listfourItemModelObj, {Key? key})
      : super(
          key: key,
        );

  // Holds the data model for this list item
  ListfourItemModel listfourItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 8.h,
      ),
      // Applies a white-gray background with rounded corners
      decoration: AppDecoration.graysWhite.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // First element: A container showing a number or identifier
          Container(
            decoration: AppDecoration.gray2,
            child: Text(
              listfourItemModelObj.four!,
              textAlign: TextAlign.center,
              style: CustomTextStyles.titleSmallPlusJakartaSansGray800,
            ),
          ),
          // Second element: A circular image, possibly a user avatar or icon
          CustomImageView(
            imagePath: listfourItemModelObj.image!,
            height: 32.h,
            width: 34.h,
            radius: BorderRadius.circular(
              16.h,
            ),
            margin: EdgeInsets.only(left: 12.h),
          ),
          // Third element: Text aligned at the bottom, likely a username or title
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: 12.h,
                bottom: 2.h,
              ),
              child: Text(
                listfourItemModelObj.garylee!,
                style: CustomTextStyles.titleSmallGray800,
              ),
            ),
          ),
          Spacer(),
          // Fourth element: A counter or score display on the far right
          Text(
            listfourItemModelObj.ptsCounter!,
            style: CustomTextStyles.bodyMediumPlusJakartaSansGray800,
          )
        ],
      ),
    );
  }
}
