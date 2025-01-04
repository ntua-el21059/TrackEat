import 'package:flutter/material.dart';
import '../../../../../core/app_export.dart';
import '../../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../../widgets/app_bar/appbar_subtitle.dart';
import '../../../../../widgets/app_bar/custom_app_bar.dart';
import '../../../../../widgets/custom_search_view.dart';
import 'models/find_friends_item_model.dart';
import 'models/find_friends_model.dart';
import 'provider/find_friends_provider.dart';
import 'widgets/find_friends_item_widget.dart';

// This screen allows users to discover and connect with potential friends.
// It provides a search functionality and displays a list of suggested connections.
class FindFriendsScreen extends StatefulWidget {
  const FindFriendsScreen({Key? key})
      : super(
          key: key,
        );

  @override
  FindFriendsScreenState createState() => FindFriendsScreenState();

  // Factory builder method that sets up the screen with its state management provider
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FindFriendsProvider(),
      child: FindFriendsScreen(),
    );
  }
}

// The state class manages the screen's behavior and appearance
class FindFriendsScreenState extends State<FindFriendsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // The main scaffold provides the screen's structure with an app bar and scrollable body
    return Scaffold(
      backgroundColor: theme.colorScheme.onErrorContainer,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppbar(context),
      body: SafeArea(
        top: false,
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Search bar section for filtering friends
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.h),
                child: Selector<FindFriendsProvider, TextEditingController?>(
                  selector: (context, provider) => provider.searchController,
                  builder: (context, searchController, child) {
                    return CustomSearchView(
                      controller: searchController,
                      hintText: "Find friends",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8.h,
                        vertical: 6.h,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 18.h),
              // Main content section showing friend suggestions
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(
                    left: 14.h,
                    top: 14.h,
                    right: 14.h,
                  ),
                  decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder10,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "People you may know",
                        style: theme.textTheme.titleLarge,
                      ),
                      SizedBox(height: 18.h),
                      _buildFindfriends(context)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Constructs the app bar with a back button and title
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftPrimary,
        margin: EdgeInsets.only(left: 4.h),
        onTap: () => Navigator.pop(context),
      ),
      title: AppbarSubtitle(
        text: "Leaderboard",
        margin: EdgeInsets.only(left: 7.h),
        onTap: () => Navigator.pop(context),
      ),
    );
  }

  // Creates the scrollable list of friend suggestions
  Widget _buildFindfriends(BuildContext context) {
    return Expanded(
      child: Consumer<FindFriendsProvider>(
        builder: (context, provider, child) {
          return ListView.separated(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemCount: provider.findFriendsModelObj.findFriendsItemList.length,
            itemBuilder: (context, index) {
              FindFriendsItemModel model =
                  provider.findFriendsModelObj.findFriendsItemList[index];
              return FindFriendsItemWidget(model);
            },
          );
        },
      ),
    );
  }
}
