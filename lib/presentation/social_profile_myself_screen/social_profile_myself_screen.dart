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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class SocialProfileMyselfScreen extends StatefulWidget {
  const SocialProfileMyselfScreen({super.key});

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
      appBar: _buildAppBar(context),
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
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(54.h),
            topRight: Radius.circular(54.h),
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
                  SizedBox(height: 12.h),
                  _buildListvegan(context),
                  SizedBox(height: 8.h),
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
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
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

  /// Section Widget
  Widget _buildRowvectorone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.all(16.h),
      decoration: null,
      child: Column(
        children: [
          Row(
            children: [
              Consumer<ProfilePictureProvider>(
                builder: (context, profilePicProvider, _) {
                  return ClipOval(
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
                          final userData = snapshot.data!.data() as Map<String, dynamic>;
                          final profilePicture = userData['profilePicture'] as String?;
                          
                          if (profilePicture != null && profilePicture.isNotEmpty) {
                            return Image.memory(
                              base64Decode(profilePicture),
                              height: 80.h,
                              width: 80.h,
                              fit: BoxFit.cover,
                            );
                          }
                        }
                        
                        return CustomImageView(
                          imagePath: ImageConstant.imgVector80x84,
                          height: 80.h,
                          width: 80.h,
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(width: 12.h),
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
                      final userData = snapshot.data!.data() as Map<String, dynamic>;
                      final firstName = userData['firstName']?.toString() ?? '';
                      final lastName = userData['lastName']?.toString() ?? '';
                      final username = userData['username']?.toString() ?? '';
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$firstName $lastName",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: const Color(0xFF37474F),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "@$username",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: const Color(0xFF37474F),
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Loading...",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: const Color(0xFF37474F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "@...",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF37474F),
                          ),
                        ),
                      ],
                    );
                  },
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
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null && snapshot.data!.exists) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final firstName = userData['firstName']?.toString() ?? '';
          final currentWeight = double.tryParse(userData['weight']?.toString() ?? '0') ?? 0;
          final goalWeight = double.tryParse(userData['weightgoal']?.toString() ?? '0') ?? 0;
          
          // Calculate progress percentage
          int progress = 0;
          if (currentWeight > 0) {
            double calculation = (1 - ((currentWeight - goalWeight) / currentWeight)) * 100;
            progress = calculation.round().clamp(0, 100); // Ensure progress is between 0 and 100
          }
          
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
                  "🎉 $firstName has hit $progress% of his weight goal!",
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
        }
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
                "Loading...",
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
                      flex: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 100,
                      child: SizedBox(),
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
}