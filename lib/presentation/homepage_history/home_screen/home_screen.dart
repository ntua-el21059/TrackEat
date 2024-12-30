import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_bottom_bar.dart';
import '../../../widgets/app_bar/appbar_subtitle_one.dart';
import '../../../widgets/app_bar/appbar_title.dart';
import '../../../widgets/app_bar/appbar_trailing_image.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import 'models/cards_item_model.dart';
import 'models/home_model.dart';
import 'provider/home_provider.dart';
import 'widgets/cards_item_widget.dart';
import 'package:activity_ring/activity_ring.dart';
import '../../../presentation/profile_screen/profile_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/profile_picture_provider.dart';
import '../../../providers/user_info_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: HomeScreen(),
    );
  }
}

class HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      appBar: _buildAppbar(context),
      body: Container(
        width: double.maxFinite,
        decoration: AppDecoration.graysWhite,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(
                    left: 4.h,
                    top: 22.h,
                    right: 4.h,
                  ),
                  child: Column(
                    children: [
                      _buildCalories(context),
                      SizedBox(height: 16.h),
                      _buildSuggestionsone(context),
                      SizedBox(height: 14.h)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: _buildBottombar(context),
    );
  }

  /// Common widget
  Widget _buildNumberandunit(
    BuildContext context, {
    required String p45seventyOne,
    required String gOne,
  }) {
    return Row(
      children: [
        Text(
          p45seventyOne,
          style: CustomTextStyles.titleLargeLimeA700.copyWith(
            color: appTheme.limeA700,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            gOne,
            style: CustomTextStyles.titleMediumLimeA700.copyWith(
              color: appTheme.limeA700,
            ),
          ),
        )
      ],
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 60.h,
      title: Padding(
        padding: EdgeInsets.only(left: 19.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppbarSubtitleOne(
              text: "WELCOME".toUpperCase(),
            ),
            Consumer<UserInfoProvider>(
              builder: (context, userInfo, _) {
                return AppbarTitle(
                  text: userInfo.fullName,
                );
              },
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(
            left: 16.h,
            right: 16.h,
            bottom: 8.h,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: Consumer<ProfilePictureProvider>(
              builder: (context, profilePicProvider, _) {
                return CustomImageView(
                  imagePath: profilePicProvider.profileImagePath,
                  isFile: !profilePicProvider.profileImagePath.startsWith('assets/'),
                  height: 40.h,
                  width: 40.h,
                  radius: BorderRadius.circular(20.h),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildCalories(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(22.h),
      decoration: BoxDecoration(
        color: const Color(0xFFB2D7FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "1500 Kcal Remaining...",
                style: CustomTextStyles.titleMediumGray90001Bold,
              ),
              Text(
                "3000 kcal",
                style: TextStyle(
                  color: const Color(0xFFFF0000),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.maxFinite,
            height: 8.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.h),
            ),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CD964),
                    borderRadius: BorderRadius.circular(4.h),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Protein",
                      style: CustomTextStyles.bodyLargeBlack90016_2,
                    ),
                    Text(
                      "78/98g",
                      style: TextStyle(
                        color: const Color(0xFFFA114F),
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Fats",
                      style: CustomTextStyles.bodyLargeBlack90016_2,
                    ),
                    Text(
                      "45/70g",
                      style: TextStyle(
                        color: const Color(0xFFA6FF00),
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Carbs",
                      style: CustomTextStyles.bodyLargeBlack90016_2,
                    ),
                    Text(
                      "95/110g",
                      style: TextStyle(
                        color: const Color(0xFF00FFF6),
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Ring(
                  percent: _isLoading ? 0 : 78 / 98 * 100,
                  color: RingColorScheme(
                    ringColor: Color(0xFFFA114F),
                    backgroundColor: Colors.grey.withOpacity(0.2),
                  ),
                  radius: 60,
                  width: 15,
                  child: Ring(
                    percent: _isLoading ? 0 : 45 / 70 * 100,
                    color: RingColorScheme(
                      ringColor: Color(0xFFA6FF00),
                      backgroundColor: Colors.grey.withOpacity(0.2),
                    ),
                    radius: 45,
                    width: 15,
                    child: Ring(
                      percent: _isLoading ? 0 : 95 / 110 * 100,
                      color: RingColorScheme(
                        ringColor: Color(0xFF00FFF6),
                        backgroundColor: Colors.grey.withOpacity(0.2),
                      ),
                      radius: 30,
                      width: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.historyTodayTabScreen);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Show History",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsone(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(
        bottom: 22.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFBAB2),
        borderRadius: BorderRadius.circular(21),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 17.h, top: 22.h),
            child: Text(
              "Suggestions",
              style: CustomTextStyles.titleMediumGray90001Bold.copyWith(
                fontSize: 22,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Consumer<HomeProvider>(
            builder: (context, provider, child) {
              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 5.h);
                },
                itemCount: provider.homeInitialModelObj.cardsItemList.length,
                itemBuilder: (context, index) {
                  CardsItemModel model = provider.homeInitialModelObj.cardsItemList[index];
                  return CardsItemWidget(model);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottombar(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {
          switch (type) {
            case BottomBarEnum.Home:
              break;
            case BottomBarEnum.Leaderboard:
              Navigator.pushNamed(context, "/leaderboard");
              break;
          }
        },
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(22.h),
      decoration: BoxDecoration(
        color: const Color(0xFFB2D7FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Consumer<ProfilePictureProvider>(
            builder: (context, profilePicProvider, _) {
              return CustomImageView(
                imagePath: profilePicProvider.profileImagePath,
                isFile: !profilePicProvider.profileImagePath.startsWith('assets/'),
                height: 40.h,
                width: 40.h,
                radius: BorderRadius.circular(20.h),
              );
            },
          ),
        ],
      ),
    );
  }
}
