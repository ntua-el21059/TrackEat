import 'package:flutter/material.dart';
import '../models/challenge_item_model.dart';
import '../../challenges/avocado_challenge_dialog/avocado_challenge_dialog.dart';
import '../../challenges/banana_challenge_dialog/banana_challenge_dialog.dart';
import '../../challenges/carnivore_challenge_dialog/carnivore_challenge_dialog.dart';
import '../../challenges/beatles_challenge_dialog/beatles_challenge_dialog.dart';
import '../../challenges/brocolli_challenge_dialog/brocolli_challenge_dialog.dart';
import '../../challenges/wrap_challenge_dialog/wrap_challenge_dialog.dart';

class ChallengeCard extends StatelessWidget {
  final ChallengeItemModel challenge;

  const ChallengeCard({Key? key, required this.challenge}) : super(key: key);

  void _showChallengeDialog(BuildContext context) {
    Widget dialogWidget;

    // Determine which dialog to show based on the challenge title
    switch (challenge.title.toLowerCase()) {
      case 'avocado\nchallenge':
        dialogWidget = AvocadoChallengeDialog.builder(context);
        break;
      case 'banana\nchallenge':
        dialogWidget = BananaChallengeDialog.builder(context);
        break;
      case 'carnivore\nchallenge':
        dialogWidget = CarnivoreChallengeDialog.builder(context);
        break;
      case 'beatles\nchallenge':
        dialogWidget = BeatlesChallengeDialog.builder(context);
        break;
      case 'broccoli\nchallenge':
        dialogWidget = BrocolliChallengeDialog.builder(context);
        break;
      case 'wrap\nchallenge':
        dialogWidget = WrapChallengeDialog.builder(context);
        break;
      default:
        return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) => dialogWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showChallengeDialog(context),
      child: Container(
        width: 110,
        height: 110,
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: challenge.backgroundColor,
          borderRadius: BorderRadius.circular(13.6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              challenge.imageUrl,
              width: challenge.title.toLowerCase() == 'beatles\nchallenge' ? 55 : (challenge.title.toLowerCase() == 'banana\nchallenge' ? 42 : 48),
              height: challenge.title.toLowerCase() == 'beatles\nchallenge' ? 55 : (challenge.title.toLowerCase() == 'banana\nchallenge' ? 42 : 48),
            ),
            SizedBox(height: challenge.title.toLowerCase() == 'beatles\nchallenge' ? 1 : 8),
            Container(
              height: 32,
              child: Text(
                challenge.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
