import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/listfour_item_model.dart';

// This widget represents an individual entry in the leaderboard list, displaying
// a user's rank, avatar, username and points in a horizontal layout
class ListfourItemWidget extends StatelessWidget {
  ListfourItemWidget(this.listfourItemModelObj, {Key? key})
      : super(
          key: key,
        );

  // Model containing the leaderboard entry data to display
  ListfourItemModel listfourItemModelObj;

  @override
  Widget build(BuildContext context) {
    // Container wraps the entire list item with padding and styling
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 8.h,
      ),
      decoration: AppDecoration.graysWhite.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      // Row arranges the rank, avatar, username and points horizontally
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Displays the user's rank number
          Container(
            decoration: AppDecoration.gray2,
            child: Text(
              listfourItemModelObj.four!,
              textAlign: TextAlign.center,
              style: CustomTextStyles.titleSmallPlusJakartaSansGray800,
            ),
          ),
          // Circular avatar image of the user
          CustomImageView(
            imagePath: listfourItemModelObj.image!,
            height: 32.h,
            width: 34.h,
            radius: BorderRadius.circular(
              16.h,
            ),
            margin: EdgeInsets.only(left: 12.h),
          ),
          // Username display, aligned slightly to the bottom
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
          // Points display on the far right
          Text(
            listfourItemModelObj.ptsCounter!,
            style: CustomTextStyles.bodyMediumPlusJakartaSansGray800,
          )
        ],
      ),
    );
  }
}
