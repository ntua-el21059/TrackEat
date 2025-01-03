import 'package:flutter/material.dart';
import '../models/challenge_item_model.dart';
import '../models/player_model.dart';

class LeaderboardProvider extends ChangeNotifier {
  final List<List<ChallengeItemModel>> challengePages = [
    [
      ChallengeItemModel(
        imageUrl: 'assets/images/avocado.png',
        title: 'Avocado\nchallenge',
        backgroundColor: Color(0xFF4CD964),
      ),
      ChallengeItemModel(
        imageUrl: 'assets/images/banana.png',
        title: 'Banana\nchallenge',
        backgroundColor: Color(0xFFFFCC00),
      ),
      ChallengeItemModel(
        imageUrl: 'assets/images/meat.png',
        title: 'Carnivore\nchallenge',
        backgroundColor: Color(0xFFFF3B30),
      ),
    ],
    [
      ChallengeItemModel(
        imageUrl: 'assets/images/beatles.png',
        title: 'Beatles\nchallenge',
        backgroundColor: Color(0xFF007AFF),
      ),
      ChallengeItemModel(
        imageUrl: 'assets/images/broccoli.png',
        title: 'Broccoli\nchallenge',
        backgroundColor: Colors.black,
      ),
      ChallengeItemModel(
        imageUrl: 'assets/images/wrap.png',
        title: 'Wrap\nchallenge',
        backgroundColor: Color(0xFF9747FF),
      ),
    ],
  ];
}
