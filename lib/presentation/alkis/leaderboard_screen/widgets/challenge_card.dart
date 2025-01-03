import 'package:flutter/material.dart';
import '../models/challenge_item_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChallengeCard extends StatelessWidget {
  final ChallengeItemModel challenge;

  const ChallengeCard({Key? key, required this.challenge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: challenge.backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            challenge.imageUrl,
            width: 32,
            height: 32,
            color: Colors.white, // Make icons white
          ),
          SizedBox(height: 8),
          Text(
            challenge.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
