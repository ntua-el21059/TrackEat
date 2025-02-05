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
                if (provider
                    .findFriendsModelObj.findFriendsItemList.isNotEmpty) ...[
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.all(14.h),
                    decoration: AppDecoration.lightBlueLayoutPadding.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (provider.searchController.text.isEmpty) ...[
                          Text(
                            "People you may know",
                            style: theme.textTheme.titleLarge,
                          ),
                          SizedBox(height: 18.h),
                        ],
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
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
                ] else ...[
                  // Search results layout
                  Expanded(
                    child: ListView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14.h, vertical: 8.h),
                      itemCount: provider
                          .findFriendsModelObj.findFriendsItemList.length,
                      itemBuilder: (context, index) {
                        FindFriendsItemModel model = provider
                            .findFriendsModelObj.findFriendsItemList[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 8.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.h, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(25.h),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (model.username != null) {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.socialProfileViewScreen,
                                  arguments: {
                                    'username': model.username,
                                    'backButtonText': 'Find Friends'
                                  },
                                );
                              }
                            },
                            child: Row(
                              children: [
                                ClipOval(
                                  child: (model.profileImage != null &&
                                          model.profileImage!.isNotEmpty)
                                      ? Image.memory(
                                          base64Decode(model.profileImage!),
                                          height: 40.h,
                                          width: 40.h,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          height: 40.h,
                                          width: 40.h,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            shape: BoxShape.circle,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/images/person.crop.circle.fill.svg',
                                            height: 40.h,
                                            width: 40.h,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                ),
                                SizedBox(width: 12.h),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        model.fullName ?? '',
                                        style: TextStyle(
                                          fontSize: 16.h,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (model.username != null)
                                        Text(
                                          "@${model.username}",
                                          style: TextStyle(
                                            fontSize: 14.h,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey[400],
                                  size: 24.h,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
        onTap: () => Navigator.pop(context),
      ),
      title: AppbarSubtitle(
        text: "Leaderboard",
        margin: EdgeInsets.only(left: 7.h),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
