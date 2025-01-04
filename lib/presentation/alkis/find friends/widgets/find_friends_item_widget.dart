import 'package:flutter/material.dart';
import '../../../../../core/app_export.dart';
import '../models/find_friends_item_model.dart';

// This widget creates an individual friend suggestion item that appears in the Find Friends list.
// Each item displays the friend's profile picture, name, and a chevron arrow for navigation.
class FindFriendsItemWidget extends StatelessWidget {
  FindFriendsItemWidget(this.findFriendsItemModelObj, {Key? key})
      : super(
          key: key,
        );

  // The model containing the friend's data to be displayed
  final FindFriendsItemModel findFriendsItemModelObj;

  @override
  Widget build(BuildContext context) {
    // The container provides the overall structure and styling for each friend item
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 18.h,
        vertical: 8.h,
      ),
      // The decoration gives each item a clean white background with rounded corners,
      // helping them stand out visually from the main background
      decoration: AppDecoration.graysWhite.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      // The row arranges the profile picture, name, and chevron horizontally
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile picture displayed as a circular image on the left
          CustomImageView(
            imagePath: findFriendsItemModelObj.oliverGrayOne!,
            height: 32.h,
            width: 34.h,
            radius: BorderRadius.circular(
              16.h,
            ),
            margin: EdgeInsets.only(left: 20.h),
          ),
          // Friend's name shown in the middle, slightly aligned to the bottom
          // for better visual balance with the profile picture
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: 12.h,
                bottom: 4.h,
              ),
              child: Text(
                findFriendsItemModelObj.garylee!,
                style: CustomTextStyles.titleSmallGray800,
              ),
            ),
          ),
          // Spacer pushes the chevron to the far right
          Spacer(),
          // Arrow icon on the right indicating this item is tappable
          CustomImageView(
            imagePath: ImageConstant.imgArrowRightBlueGray400,
            height: 24.h,
            width: 24.h,
            margin: EdgeInsets.only(right: 8.h),
          )
        ],
      ),
    );
  }
}
