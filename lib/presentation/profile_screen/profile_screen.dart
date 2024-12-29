import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'models/profile_item_model.dart';
import 'models/profile_model.dart';
import 'provider/profile_provider.dart';
import 'widgets/profile_item_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 4.h),
          child: Column(
            children: [
              _buildProfileHeader(context),
              SizedBox(height: 16.h),
              _buildProfilePreview(context),
              SizedBox(height: 16.h),
              _buildActivityLevelSection(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 38.h,
      leadingWidth: 24.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftPrimary,
        margin: EdgeInsets.only(left: 8.h),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: AppbarSubtitle(
        text: "Home",
        margin: EdgeInsets.only(left: 7.h),
      ),
    );
  }

  /// Section Widget
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile",
                  style: theme.textTheme.displaySmall,
                )
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "PREVIEW PROFILE".toUpperCase(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: const Color(0xFF8E8E93),
                      ),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgArrowRightBlueGray400,
                      height: 10.h,
                      width: 8.h,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildProfilePreview(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 26.h,
        vertical: 20.h,
      ),
      margin: EdgeInsets.symmetric(horizontal: 4.h),
      decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<ProfileProvider>(
            builder: (context, provider, child) {
              return CustomImageView(
                imagePath: provider.profileImagePath,
                height: 72.h,
                width: 72.h,
                radius: BorderRadius.circular(36.h),
                alignment: Alignment.center,
                isFile: !provider.profileImagePath.startsWith('assets/'),
              );
            },
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.profileStaticScreen);
              },
              child: Container(
                margin: EdgeInsets.only(top: 4.h),
                padding: EdgeInsets.symmetric(horizontal: 12.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "John Appleseed",
                            style: theme.textTheme.titleLarge,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "@jappleseed",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgArrowRight,
                      height: 30.h,
                      width: 18.h,
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(
                        right: 2.h,
                        bottom: 10.h,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildActivityLevelSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 10.h,
        vertical: 12.h,
      ),
      margin: EdgeInsets.symmetric(horizontal: 4.h),
      decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: 4.h);
            },
            itemCount: provider.profileModelObj.profileItemList.length,
            itemBuilder: (context, index) {
              ProfileItemModel model =
                  provider.profileModelObj.profileItemList[index];
              return ProfileItemWidget(model);
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileItem(
    String title,
    String value,
    String imagePath,
    {EdgeInsets? iconPadding, double? iconWidth, double? iconHeight, Alignment? alignment}
  ) {
    return Container(
      // ... other widget properties
      child: Row(
        children: [
          // ... left side widgets
          Text(
            // Add space for kg units, remove space for others
            value?.replaceAll('kg', ' kg')  // First add space before all 'kg'
                .replaceAll(' g', 'g')            // Remove space before 'g'
                .replaceAll(' kcal', 'kcal') ?? '',  // Remove space before 'kcal'
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          // ... right side widgets
        ],
      ),
    );
  }
}