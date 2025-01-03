import 'package:flutter/material.dart';
import '../models/challenge_item_model.dart';
import '../models/player_model.dart';

class LeaderboardProvider extends ChangeNotifier {
  final List<Player> players = [
    Player(
      name: 'nancy_reagan',
      imageUrl: 'https://i.pravatar.cc/150?img=4',
      points: 36,
    ),
    Player(
      name: 'sophia.richardson',
      imageUrl: 'https://i.pravatar.cc/150?img=5',
      points: 35,
    ),
    Player(
      name: 'jappleseed',
      imageUrl: 'https://i.pravatar.cc/150?img=6',
      points: 34,
    ),
    Player(
      name: 'emmasullivan',
      imageUrl: 'https://i.pravatar.cc/150?img=7',
      points: 33,
    ),
    Player(
      name: 'liam_mitchell',
      imageUrl: 'https://i.pravatar.cc/150?img=8',
      points: 32,
    ),
  ];

  // First page of challenges
  final List<List<ChallengeItemModel>> challengePages = [
    [
      ChallengeItemModel(
        imageUrl: 'assets/images/avocado.svg',
        title: 'Avocado\nchallenge',
        backgroundColor: Color(0xFF4CD964),
      ),
      ChallengeItemModel(
        imageUrl: 'assets/images/banana.svg',
        title: 'Banana\nchallenge',
        backgroundColor: Color(0xFFFFCC00),
      ),
      ChallengeItemModel(
        imageUrl: 'assets/images/meat.svg',
        title: 'Carnivore\nchallenge',
        backgroundColor: Color(0xFFFF3B30),
      ),
    ],
    // Second page of challenges
    [
      ChallengeItemModel(
        imageUrl: 'assets/images/beatles.svg',
        title: 'Beatles\nchallenge',
        backgroundColor: Color(0xFF007AFF),
      ),
      ChallengeItemModel(
        imageUrl: 'assets/images/broccoli.svg',
        title: 'Broccoli\nchallenge',
        backgroundColor: Color(0xFF000000),
      ),
      ChallengeItemModel(
        imageUrl: 'assets/images/wrap.svg',
        title: 'Wrap\nchallenge',
        backgroundColor: Color(0xFF9747FF),
      ),
    ],
  ];
}
