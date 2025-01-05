import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/find_friends_item_model.dart';
import '../../../../routes/app_routes.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

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
          ClipOval(
            child: (findFriendsItemModelObj.profileImage != null && findFriendsItemModelObj.profileImage!.isNotEmpty)
              ? Image.memory(
                  base64Decode(findFriendsItemModelObj.profileImage!),
                  height: 32.h,
                  width: 32.h,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 32.h,
                  width: 32.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/images/person.crop.circle.fill.svg',
                    height: 32.h,
                    width: 32.h,
                    fit: BoxFit.cover,
                  ),
                ),
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
          GestureDetector(
            onTap: () {
              print('Tapped on user: ${findFriendsItemModelObj.username}');
              if (findFriendsItemModelObj.username != null) {
                print('Navigating to profile for user: ${findFriendsItemModelObj.username}');
                Navigator.pushNamed(
                  context,
                  AppRoutes.socialProfileViewScreen,
                  arguments: {'username': findFriendsItemModelObj.username},
                );
              }
            },
            child: CustomImageView(
              imagePath: ImageConstant.imgArrowRight,
              height: 24.h,
              width: 24.h,
              margin: EdgeInsets.only(right: 8.h),
              color: appTheme.blue100,
            ),
          )
        ],
      ),
    );
  }
}
