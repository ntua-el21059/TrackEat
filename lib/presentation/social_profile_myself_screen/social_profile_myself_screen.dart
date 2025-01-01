import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_subtitle.dart';
import '../../widgets/app_bar/appbar_subtitle_two.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../profile_screen/provider/profile_provider.dart';
import 'models/gridvector_one_item_model.dart';
import 'models/listvegan_item_model.dart';
import 'provider/social_profile_myself_provider.dart';
import 'widgets/gridvector_one_item_widget.dart';
import 'widgets/listvegan_item_widget.dart';
import '../../providers/profile_picture_provider.dart';
import '../../providers/user_info_provider.dart';

class SocialProfileMyselfScreen extends StatefulWidget {
  const SocialProfileMyselfScreen({Key? key}) : super(key: key);

  @override
  SocialProfileMyselfScreenState createState() => SocialProfileMyselfScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SocialProfileMyselfProvider()..init(context),
      child: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          // Get current diet and update social provider
          final diet = profileProvider.profileModelObj.profileItemList
              .firstWhere((item) => item.title == "Diet")
              .value;
          
          Provider.of<SocialProfileMyselfProvider>(context, listen: false)
              .updateDietBox(diet ?? 'Carnivore');
          
          return const SocialProfileMyselfScreen();
        },
      ),
    );
  }
}

class SocialProfileMyselfScreenState extends State<SocialProfileMyselfScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for the widget to be built before accessing providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SocialProfileMyselfProvider>(context, listen: false).init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: const Color(0xFFB2D7FF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(54.h),
            topRight: Radius.circular(54.h),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 8.h,
              top: 8.h,
              right: 8.h,
              bottom: MediaQuery.of(context).padding.bottom + 18.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildRowvectorone(context),
                SizedBox(height: 6.h),
                _buildWeightgoal(context),
                SizedBox(height: 22.h),
                _buildListvegan(context),
                SizedBox(height: 15.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.h),
                    child: Text(
                      "Awards",
                      style: CustomTextStyles.headlineSmallOnErrorContainerBold,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                _buildGridvectorone(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 23.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftPrimary,
        margin: EdgeInsets.only(left: 7.h),
        onTap: () => Navigator.pop(context),
      ),
      title: AppbarSubtitle(
        text: "Profile",
        margin: EdgeInsets.only(left: 7.h),
      ),
      actions: [
        AppbarSubtitleTwo(
          text: "PROFILE PREVIEW".toUpperCase(),
          margin: EdgeInsets.only(
            right: 20.h,
            bottom: 3.h,
          ),
        )
      ],
    );
  }

  /// Section Widget
  Widget _buildRowvectorone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFB2D7FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Consumer<ProfilePictureProvider>(
                builder: (context, profilePicProvider, _) {
                  return ClipOval(
                    child: CustomImageView(
                      imagePath: profilePicProvider.profileImagePath,
                      isFile: !profilePicProvider.profileImagePath.startsWith('assets/'),
                      height: 80.h,
                      width: 80.h,
                      radius: BorderRadius.circular(40.h),
                    ),
                  );
                },
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<UserInfoProvider>(
                      builder: (context, userInfo, _) {
                        return Text(
                          userInfo.fullName,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: const Color(0xFF37474F),
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                    Text(
                      "@${context.watch<UserInfoProvider>().username}",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF37474F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  text: "Add Friend",
                  height: 48.h,
                  rightIcon: Container(
                    margin: EdgeInsets.only(left: 6.h),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgAddFriend,
                      height: 16.h,
                      width: 16.h,
                      fit: BoxFit.contain,
                      color: Colors.white,
                    ),
                  ),
                  buttonStyle: CustomButtonStyles.fillBlueGrayTL16,
                  buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                ),
              ),
              SizedBox(width: 14.h),
              Expanded(
                child: CustomElevatedButton(
                  text: "Message",
                  height: 48.h,
                  buttonStyle: CustomButtonStyles.fillBlueGrayTL16,
                  buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildWeightgoal(BuildContext context) {
    return Consumer<SocialProfileMyselfProvider>(
      builder: (context, provider, _) {
        final progress = provider.weightGoalProgress;
        
        return Container(
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            color: const Color(0xFF8FB8E0).withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "🎉 John has hit ${progress}% of his weight goal!",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                height: 8.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.h),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 100 - progress,
                      child: const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildListvegan(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      width: double.maxFinite,
      child: Consumer<SocialProfileMyselfProvider>(
        builder: (context, provider, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                provider.socialProfileMyselfModelObj.listveganItemList.length,
                (index) {
                  ListveganItemModel model =
                      provider.socialProfileMyselfModelObj.listveganItemList[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index == 0 ? 16.h : 0,
                    ),
                    child: ListveganItemWidget(model),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildGridvectorone(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.h),
      child: Consumer<SocialProfileMyselfProvider>(
        builder: (context, provider, child) {
          return ResponsiveGridListBuilder(
            minItemWidth: 1,
            minItemsPerRow: 3,
            maxItemsPerRow: 3,
            horizontalGridSpacing: 18.h,
            verticalGridSpacing: 18.h,
            builder: (context, items) => ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              children: items,
            ),
            gridItems: List.generate(
              provider.socialProfileMyselfModelObj.gridvectorOneItemList.length,
              (index) {
                GridvectorOneItemModel model =
                    provider.socialProfileMyselfModelObj.gridvectorOneItemList[index];
                return GridvectorOneItemWidget(
                  model,
                  index: index,
                );
              },
            ),
          );
        },
      ),
    );
  }
}