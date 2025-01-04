import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/custom_bottom_bar.dart';
import 'models/challenge_item_model.dart';
import 'provider/leaderboard_provider.dart';
import 'widgets/challenge_card.dart';
import '../notifications/notifications_screen.dart';
import '../notifications/provider/notifications_provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();

  // Factory builder method that sets up the screen with its state management provider
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
                    : ListView.builder(
                        itemCount: provider.users.length,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final user = provider.users[index];
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 4),
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                              backgroundColor:
                                  user.isCurrentUser ? Colors.blue : null,
                            ),
                            title: Text(
                              user.fullName.isNotEmpty
                                  ? user.fullName
                                  : '@${user.username}',
                              style: TextStyle(
                                fontWeight:
                                    user.isCurrentUser ? FontWeight.bold : null,
                              ),
                            ),
                            subtitle: user.fullName.isNotEmpty
                                ? Text('@${user.username}')
                                : null,
                            trailing: Text(
                              '${user.points} pts',
                              style: TextStyle(
                                fontWeight:
                                    user.isCurrentUser ? FontWeight.bold : null,
                              ),
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
