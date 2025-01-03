import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/custom_bottom_bar.dart';
import 'models/challenge_item_model.dart';
import 'provider/leaderboard_provider.dart';
import 'widgets/challenge_card.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final PageController _challengesController = PageController();

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
    return ChangeNotifierProvider(
      create: (_) => LeaderboardProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Leaderboard'),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
          ],
        ),
        body: Consumer<LeaderboardProvider>(
          builder: (context, provider, _) => Column(
            children: [
              // Leaderboard list
              Expanded(
                flex: 2,
                child: ListView.builder(
                  itemCount: 5, // Number of top players
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Text('Player ${index + 1}'),
                      trailing: Text('${40 - index * 2} pts'),
                    );
                  },
                ),
              ),

              // Find Friends button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () {},
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
                          (index) => _buildPageIndicator(index),
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
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _challengesController.hasClients &&
                _challengesController.page?.round() == index
            ? Colors.blue
            : Colors.grey,
      ),
    );
  }
}
