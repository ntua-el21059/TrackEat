import 'package:flutter/material.dart';
import '../../../../../core/app_export.dart';
import '../models/find_friends_item_model.dart';

class FindFriendsItemWidget extends StatelessWidget {
  FindFriendsItemWidget(this.findFriendsItemModelObj, {Key? key})
      : super(key: key);

  final FindFriendsItemModel findFriendsItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 18.h,
        vertical: 8.h,
      ),
      decoration: AppDecoration.graysWhite.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: findFriendsItemModelObj.profileImage,
            height: 32.h,
            width: 34.h,
            radius: BorderRadius.circular(16.h),
            margin: EdgeInsets.only(left: 20.h),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 12.h,
                bottom: 4.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    findFriendsItemModelObj.fullName ?? '',
                    style: CustomTextStyles.titleSmallGray800,
                  ),
                  if (findFriendsItemModelObj.username != null)
                    Text(
                      "@${findFriendsItemModelObj.username}",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: appTheme.blueGray400,
                      ),
                    ),
                ],
              ),
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgArrowRight,
            height: 24.h,
            width: 24.h,
            margin: EdgeInsets.only(right: 8.h),
            color: appTheme.blue100,
          )
        ],
      ),
    );
  }
}
