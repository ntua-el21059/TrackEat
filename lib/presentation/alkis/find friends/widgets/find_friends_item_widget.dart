import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/find_friends_item_model.dart';
import '../../../../routes/app_routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../provider/find_friends_provider.dart';

class FindFriendsItemWidget extends StatelessWidget {
  FindFriendsItemWidget(this.findFriendsItemModelObj, {Key? key})
      : super(key: key);

  final FindFriendsItemModel findFriendsItemModelObj;

  Widget _buildDefaultAvatar() {
    return Container(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FindFriendsProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        if (findFriendsItemModelObj.username != null) {
          Navigator.pushNamed(
            context,
            AppRoutes.socialProfileViewScreen,
            arguments: {
              'username': findFriendsItemModelObj.username,
              'backButtonText': 'Find Friends'
            },
          );
        }
      },
      child: Container(
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
              child: SizedBox(
                height: 32.h,
                width: 32.h,
                child: (findFriendsItemModelObj.profileImage != null &&
                        findFriendsItemModelObj.profileImage!.isNotEmpty)
                    ? provider.getCachedImage(
                            findFriendsItemModelObj.profileImage) ??
                        _buildDefaultAvatar()
                    : _buildDefaultAvatar(),
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
            CustomImageView(
              imagePath: ImageConstant.imgArrowRight,
              height: 24.h,
              width: 24.h,
              margin: EdgeInsets.only(right: 8.h),
              color: appTheme.blue100,
            ),
          ],
        ),
      ),
    );
  }
}
