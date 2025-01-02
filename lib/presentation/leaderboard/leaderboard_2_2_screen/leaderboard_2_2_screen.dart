import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// Additional imports for app-specific widgets and styles
import '../../../../../core/app_export.dart';
import '../../../../../theme/custom_button_style.dart';
import '../../../../../widgets/app_bar/appbar_title.dart';
import '../../../../../widgets/app_bar/appbar_trailing_image.dart';
import '../../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../../widgets/custom_bottom_bar.dart';
import '../../../../../widgets/custom_elevated_button.dart';
// Imports for models and widgets used in this screen
import 'models/challenges2two_item_model.dart';
import 'models/leaderboard_2_2_model.dart';
import 'models/listfour_item_model.dart';
import 'provider/leaderboard_2_2_provider.dart';
import 'widgets/challenges2two_item_widget.dart';
import 'widgets/listfour_item_widget.dart';

// Main screen widget that displays the leaderboard and challenges
class Leaderboard22Screen extends StatefulWidget {
  const Leaderboard22Screen({Key? key})
      : super(
          key: key,
        );

  @override
  Leaderboard22ScreenState createState() => Leaderboard22ScreenState();

  // Factory builder that sets up the screen with its provider
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Leaderboard22Provider(),
      child: Leaderboard22Screen(),
    );
  }
}

// State class managing the Leaderboard screen
class Leaderboard22ScreenState extends State<Leaderboard22Screen> {
  // Navigator key for handling navigation from bottom bar
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Main scaffold with appbar, body sections and bottom navigation
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      appBar: _buildAppbar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(
            left: 6.h,
            top: 22.h,
            right: 6.h,
          ),
          // Main column containing all screen sections
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildLeaderboard(context),
              SizedBox(height: 8.h),
              // Friend finder button
              CustomElevatedButton(
                height: 22.h,
                width: 100.h,
                text: "Find Friends",
                margin: EdgeInsets.only(right: 6.h),
                rightIcon: Container(
                  margin: EdgeInsets.only(left: 4.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgSearch,
                    height: 10.h,
                    width: 10.h,
                    fit: BoxFit.contain,
                  ),
                ),
                buttonStyle: CustomButtonStyles.fillPrimaryTL10,
                buttonTextStyle: theme.textTheme.bodySmall,
                alignment: Alignment.centerRight,
              ),
              SizedBox(height: 10.h),
              // Challenges section header
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Text(
                    "Challenges",
                    style: CustomTextStyles.bodyLargeBlack90018,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              _buildChallenges2two(context),
              SizedBox(height: 22.h),
              // Carousel indicator dots
              Consumer<Leaderboard22Provider>(
                builder: (context, provider, child) {
                  return SizedBox(
                    height: 24.h,
                    child: AnimatedSmoothIndicator(
                      activeIndex: provider.sliderIndex,
                      count: provider
                          .leaderboard22ModelObj.challenges2twoItemList.length,
                      axisDirection: Axis.horizontal,
                      effect: ExpandingDotsEffect(
                        spacing: 8,
                        activeDotColor: appTheme.black900.withOpacity(0.3),
                        dotColor: appTheme.black900,
                        dotHeight: 8.h,
                        dotWidth: 8.h,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.maxFinite,
        child: _buildBottombar(context),
      ),
    );
  }

  // Custom app bar with title and notification bell
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      title: AppbarTitle(
        text: "Leaderboard",
        margin: EdgeInsets.only(left: 18.h),
      ),
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgBell1,
          height: 32.h,
          width: 32.h,
          margin: EdgeInsets.only(right: 32.h),
        )
      ],
    );
  }

  // Leaderboard section showing user rankings in a list
  Widget _buildLeaderboard(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 12.h,
      ),
      decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<Leaderboard22Provider>(
            builder: (context, provider, child) {
              return ListView.separated(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 8.h,
                  );
                },
                itemCount:
                    provider.leaderboard22ModelObj.listfourItemList.length,
                itemBuilder: (context, index) {
                  ListfourItemModel model =
                      provider.leaderboard22ModelObj.listfourItemList[index];
                  return ListfourItemWidget(
                    model,
                  );
                },
              );
            },
          ),
          SizedBox(height: 8.h)
        ],
      ),
    );
  }

  // Challenge carousel showing available challenges
  Widget _buildChallenges2two(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Consumer<Leaderboard22Provider>(
        builder: (context, provider, child) {
          return CarouselSlider.builder(
            options: CarouselOptions(
              height: 108.h,
              initialPage: 0,
              autoPlay: true,
              viewportFraction: 0.29,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                context.read<Leaderboard22Provider>().changeSliderIndex(index);
              },
            ),
            itemCount:
                provider.leaderboard22ModelObj.challenges2twoItemList.length,
            itemBuilder: (context, index, realIndex) {
              Challenges2twoItemModel model =
                  provider.leaderboard22ModelObj.challenges2twoItemList[index];
              return Challenges2twoItemWidget(
                model,
              );
            },
          );
        },
      ),
    );
  }

  // Bottom navigation bar widget
  Widget _buildBottombar(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: CustomBottomBar(
        onChanged: (BottomBarEnum type) {
          Navigator.pushNamed(
              navigatorKey.currentContext!, getCurrentRoute(type));
        },
      ),
    );
  }

  // Navigation route handler for bottom bar
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        return AppRoutes.homeInitialPage;
      case BottomBarEnum.Leaderboard:
        return "/";
      default:
        return "/";
    }
  }
}
