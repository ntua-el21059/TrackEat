import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/custom_bottom_bar.dart';
import 'models/challenge_item_model.dart';
import 'provider/leaderboard_provider.dart';
import 'widgets/challenge_card.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();

  static Widget builder(BuildContext context) {
    return LeaderboardScreen();
  }
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final PageController _challengesController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _challengesController.dispose();
    super.dispose();
  }

  Widget _buildPageIndicator(int index) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.blue : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Leaderboard',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<LeaderboardProvider>(
        builder: (context, provider, _) => Column(
          children: [
            // Leaderboard list with light blue background
            Container(
              color: Color(0xFFE6F3FF),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: provider.players.length,
                itemBuilder: (context, index) {
                  final player = provider.players[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFFE6E6FA),
                        child: Text('${index + 1}'),
                      ),
                      title: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(player.imageUrl),
                            radius: 15,
                          ),
                          SizedBox(width: 8),
                          Text(player.name),
                        ],
                      ),
                      trailing: Text('${player.points} pts'),
                    ),
                  );
                },
              ),
            ),

            // Find Friends button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Find Friends'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF9747FF),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),

            // Challenges section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Challenges',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: PageView.builder(
                      controller: _challengesController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      itemCount: provider.challengePages.length,
                      itemBuilder: (context, pageIndex) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: provider.challengePages[pageIndex]
                              .map((challenge) => ChallengeCard(
                                    challenge: challenge,
                                  ))
                              .toList(),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      provider.challengePages.length,
                      (index) => _buildPageIndicator(index),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        onChanged: (BottomBarEnum type) {
          switch (type) {
            case BottomBarEnum.Home:
              Navigator.pop(context);
              break;
            case BottomBarEnum.Leaderboard:
              break;
            case BottomBarEnum.AI:
              Navigator.pushNamed(context, '/ai_chat_main');
              break;
          }
        },
      ),
    );
  }
}
