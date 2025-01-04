import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_export.dart';
import '../../../core/utils/size_utils.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/custom_bottom_bar.dart';
import 'models/challenge_item_model.dart';
import 'provider/leaderboard_provider.dart';
import 'widgets/challenge_card.dart';
import '../notifications/notifications_screen.dart';
import '../notifications/provider/notifications_provider.dart';
import '../../../widgets/custom_image_view.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LeaderboardProvider(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Leaderboard'),
        actions: [
          Consumer<NotificationsProvider>(
            builder: (context, notificationsProvider, _) => IconButton(
              icon: Icon(
                notificationsProvider.hasUnreadNotifications
                    ? Icons.notifications
                    : Icons.notifications_outlined,
                color: notificationsProvider.hasUnreadNotifications
                    ? Colors.black
                    : null,
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
        ],
      ),
      body: Consumer<LeaderboardProvider>(
        builder: (context, provider, _) => Column(
          children: [
            // Leaderboard list
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFE3F2FD), // Light blue background
                  borderRadius: BorderRadius.circular(10),
                ),
                child: provider.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemCount: provider.users.length,
                        padding: EdgeInsets.only(
                          left: 16.h,
                          right: 16.h,
                          top: 32.h, // Add significant top padding
                          bottom: 16.h,
                        ),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final user = provider.users[index];
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.h,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: user.isCurrentUser
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
                            child: Row(
                              children: [
                                // Ranking number
                                Container(
                                  width: 24.h,
                                  child: Text(
                                    '${index + 4}', // Starting from 4 as per design
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
                                CustomImageView(
                                  imagePath: user.profileImage ??
                                      ImageConstant.imgVector80x84,
                                  height: 32.h,
                                  width: 32.h,
                                  radius: BorderRadius.circular(16.h),
                                ),
                                SizedBox(width: 12.h),
                                // Username
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
                                // Points
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
                          );
                        },
                      ),
              ),
            ),

            // Find Friends button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.findFriendsScreen);
                },
                child: Text('Find Friends'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 40),
                ),
              ),
            ),

            // Challenges section
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    child: Text(
                      'Challenges',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _challengesController,
                      itemCount: provider.challengePages.length,
                      itemBuilder: (context, pageIndex) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: provider.challengePages[pageIndex]
                              .map((challenge) {
                            return ChallengeCard(challenge: challenge);
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        provider.challengePages.length,
                        (index) => Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Color(0xFF9747FF) // Purple for active dot
                                : Colors.grey.withOpacity(
                                    0.3), // More transparent grey for inactive
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Spacer to push content up from bottom bar
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        onChanged: _handleBottomBarSelection,
      ),
    );
  }
}
