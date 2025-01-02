import 'package:flutter/material.dart';
import '../models/challenge_item_model.dart';

class ChallengeCard extends StatelessWidget {
  final ChallengeItemModel challenge;

  const ChallengeCard({Key? key, required this.challenge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 100,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              challenge.imageUrl,
              width: 50,
              height: 50,
            ),
            Text(
              challenge.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
