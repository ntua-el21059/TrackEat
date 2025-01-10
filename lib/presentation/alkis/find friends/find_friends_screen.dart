import 'package:flutter/material.dart';
import '../../../../../core/app_export.dart';
import '../../../../../widgets/app_bar/appbar_leading_image.dart';
import '../../../../../widgets/app_bar/appbar_subtitle.dart';
import '../../../../../widgets/app_bar/custom_app_bar.dart';
import 'models/find_friends_item_model.dart';
import 'provider/find_friends_provider.dart';
import 'widgets/find_friends_item_widget.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FindFriendsProvider>().fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FindFriendsProvider>(
      builder: (context, provider, _) => Scaffold(
        backgroundColor: theme.colorScheme.onErrorContainer,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppbar(context),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.h),
            child: Column(
              children: [
                // Search bar section
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.h,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(15.h),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.grey[500],
                        size: 20.h,
                      ),
                      SizedBox(width: 8.h),
                      Expanded(
                        child: Focus(
                          onFocusChange: (hasFocus) {
                            if (!hasFocus) {
                              provider.searchFocusNode.unfocus();
                            }
                            setState(() {});
                          },
                          child: TextField(
                            controller: provider.searchController,
                            focusNode: provider.searchFocusNode,
                            onChanged: (query) {
                              provider.searchUsers(query);
                            },
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16.h,
                            ),
                            decoration: InputDecoration(
                              hintText: "Find friends",
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16.h,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      if (provider.searchFocusNode.hasFocus)
                        GestureDetector(
                          onTap: () {
                            provider.cancelSearch();
                          },
                          child: Icon(
                            Icons.clear,
                            color: Colors.grey[500],
                            size: 20.h,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),

                // Content section
                if (provider.findFriendsModelObj.findFriendsItemList.isNotEmpty)
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.all(14.h),
                    decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (provider.searchController.text.isEmpty)
                          Column(
                            children: [
                              Text(
                                "People you may know",
                                style: theme.textTheme.titleLarge,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 18.h),
                            ],
                          ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 8.h),
                          itemCount: provider
                              .findFriendsModelObj.findFriendsItemList.length,
                          itemBuilder: (context, index) {
                            FindFriendsItemModel model = provider
                                .findFriendsModelObj.findFriendsItemList[index];
                            return FindFriendsItemWidget(model);
                          },
                        ),
                      ],
                    ),
                  ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 20.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeftPrimary,
        margin: EdgeInsets.only(left: 4.h),
        onTap: () => Navigator.pushReplacementNamed(
            context, AppRoutes.leaderboardScreen),
      ),
      title: AppbarSubtitle(
        text: "Leaderboard",
        margin: EdgeInsets.only(left: 7.h),
        onTap: () => Navigator.pushReplacementNamed(
            context, AppRoutes.leaderboardScreen),
      ),
    );
  }
}
