import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_export.dart';
import '../../../core/utils/size_utils.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/custom_bottom_bar.dart';
import '../../../widgets/app_bar/custom_app_bar.dart';
import '../../social_profile_myself_screen/social_profile_myself_screen.dart';
import 'provider/leaderboard_provider.dart';
import 'widgets/challenge_card.dart';
import '../notifications/notifications_screen.dart';
import '../notifications/provider/notifications_provider.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../services/profile_picture_cache_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();

  static Widget builder(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LeaderboardProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ProfilePictureCacheService(),
        ),
      ],
      child: LeaderboardScreen(),
    );
  }
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final PageController _challengesController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _challengesController.addListener(() {
      int newPage = _challengesController.page?.round() ?? 0;
      if (_currentPage != newPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });

    // Fetch users when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaderboardProvider>().fetchUsers();
    });
  }

  @override
  void dispose() {
    _challengesController.dispose();
    super.dispose();
  }

  void _handleBottomBarSelection(BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Home:
        Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
        break;
      case BottomBarEnum.AI:
        Navigator.pushReplacementNamed(context, AppRoutes.aiChatMainScreen);
        break;
      case BottomBarEnum.Leaderboard:
        break;
    }
  }

  Widget _buildProfilePicture(String? profileImage, double size) {
    if (profileImage != null && profileImage.isNotEmpty) {
      final decodedImage = base64Decode(profileImage);
      return Image.memory(
        decodedImage,
        height: size,
        width: size,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    }
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        'assets/images/person.crop.circle.fill.svg',
        height: size,
        width: size,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          height: 70.h,
          title: Padding(
            padding: EdgeInsets.only(left: 19.h),
            child: Text(
              'Leaderboard',
              style: theme.textTheme.headlineMedium!.copyWith(
                color: appTheme.black900,
              ),
            ),
          ),
          actions: [
            Consumer<NotificationsProvider>(
              builder: (context, notificationsProvider, _) => Padding(
                padding: EdgeInsets.only(right: 16.h),
                child: IconButton(
                  icon: SvgPicture.asset(
                    notificationsProvider.hasUnreadNotifications
                        ? 'assets/images/bell_icon_unread.svg'
                        : 'assets/images/bell_icon_read.svg',
                    height: 32.h,
                    width: 32.h,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        body: Consumer2<LeaderboardProvider, ProfilePictureCacheService>(
          builder: (context, provider, cacheService, _) => Column(
            children: [
              // Leaderboard list
              Expanded(
                flex: 6,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 9.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB2D7FF),
                    borderRadius: BorderRadius.circular(13.6),
                  ),
                  child: ListView.separated(
                    itemCount: provider.users.isEmpty ? 3 : provider.users.length,
                    padding: EdgeInsets.only(
                      left: 16.h,
                      right: 16.h,
                      top: 32.h,
                      bottom: 16.h,
                    ),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 8.h),
                    itemBuilder: (context, index) {
                      final user = provider.users[index];
                      final bool isEmpty = user.username.isEmpty;
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.h,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: user.isCurrentUser && !isEmpty
                              ? Color(0xFF007AFF)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(15.h),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: isEmpty ? Row(
                          children: [
                            Container(
                              width: 24.h,
                              height: 16.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(width: 12.h),
                            Container(
                              width: 32.h,
                              height: 32.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 12.h),
                            Container(
                              width: 80.h,
                              height: 16.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 40.h,
                              height: 16.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ) : GestureDetector(
                          onTap: () {
                            if (user.isCurrentUser) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SocialProfileMyselfScreen
                                          .builderFromLeaderboard(
                                            context,
                                            backButtonText: "Leaderboard",
                                          ),
                                ),
                              );
                            } else {
                              print('Navigating to profile view from leaderboard with username: ${user.username}');
                              Navigator.pushNamed(
                                context,
                                AppRoutes.socialProfileViewScreen,
                                arguments: {
                                  'username': user.username,
                                  'backButtonText': 'Leaderboard',
                                  'appBarTitle': 'Profile'
                                },
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 24.h,
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: user.isCurrentUser
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16.h,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // Profile picture
                              ClipOval(
                                child: _buildProfilePicture(
                                  cacheService.getCachedProfilePicture(
                                          user.email) ??
                                      user.profileImage,
                                  32.h,
                                ),
                              ),
                              SizedBox(width: 12.h),
                              Text(
                                '@${user.username}',
                                style: TextStyle(
                                  color: user.isCurrentUser
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16.h,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Spacer(),
                              Text(
                                '${user.points} pts',
                                style: TextStyle(
                                  color: user.isCurrentUser
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16.h,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Find Friends button
              Padding(
                padding: EdgeInsets.only(right: 9.h, left: 9.h, bottom: 8.h),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.findFriendsScreen);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Find Friends',
                          style: TextStyle(
                            fontSize: 14.h,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 6.h),
                        SvgPicture.asset(
                          'assets/images/magnifyingglass.svg',
                          height: 13.h,
                          width: 13.h,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                          cacheColorFilter: true,
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(120.h, 28.h),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.h),
                      backgroundColor: const Color(0xFF007AFF),
                    ),
                  ),
                ),
              ),

              // Challenges section
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.translate(
                      offset: Offset(0, -12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.h, 0, 16.h, 0),
                            child: Text(
                              'Challenges',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          SizedBox(
                            height: 140.h,
                            child: Column(
                              children: [
                                Expanded(
                                  child: PageView.builder(
                                    controller: _challengesController,
                                    itemCount: provider.challengePages.length,
                                    itemBuilder: (context, pageIndex) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: provider.challengePages[pageIndex]
                                            .map((challenge) {
                                          return ChallengeCard(challenge: challenge);
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 5.h),
                                      decoration: BoxDecoration(
                                        color: Color(0xFFE5E5EA),
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(
                                          provider.challengePages.length,
                                          (index) => Container(
                                            width: 6.0,
                                            height: 6.0,
                                            margin: EdgeInsets.symmetric(horizontal: 3.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _currentPage == index
                                                  ? Color(0xFF000000)
                                                  : Color(0xFF8E8E93),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomBar(
          onChanged: _handleBottomBarSelection,
        ),
      ),
    );
  }
}
