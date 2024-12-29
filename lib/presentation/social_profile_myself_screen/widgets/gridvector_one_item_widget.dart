import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/gridvector_one_item_model.dart';
import '../../../presentation/challenge_award_screen/challenge_award_screen.dart';

// ignore_for_file: must_be_immutable
class GridvectorOneItemWidget extends StatelessWidget {
  final GridvectorOneItemModel model;
  final int index;

  const GridvectorOneItemWidget(this.model, {Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.pushNamed(context, AppRoutes.challengeAwardScreen);
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeAwardScreen.builder(context, awardIndex: 1),
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeAwardScreen.builder(context, awardIndex: 2),
            ),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeAwardScreen.builder(context, awardIndex: 3),
            ),
          );
        } else if (index == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeAwardScreen.builder(context, awardIndex: 4),
            ),
          );
        } else if (index == 5) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengeAwardScreen.builder(context, awardIndex: 5),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Image.asset(
          model.image ?? '',
          height: 100.h,
          width: 100.h,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading image: $error');
            return Container(
              padding: EdgeInsets.all(8.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error),
                  const SizedBox(height: 4),
                  Text(
                    'Error: ${model.image}',
                    style: const TextStyle(fontSize: 8),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}