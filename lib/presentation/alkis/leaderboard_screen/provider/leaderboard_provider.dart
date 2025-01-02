import 'package:flutter/material.dart';
import '../models/challenge_item_model.dart';
import '../../../../core/constants/image_constants.dart';

class LeaderboardProvider extends ChangeNotifier {
  final List<List<ChallengeItemModel>> challengePages = [
    [
      ChallengeItemModel(
        imageUrl: ImageConstant.imgVector76x86,
        title: "Avocado\nchallenge",
      ),
      ChallengeItemModel(
        imageUrl: ImageConstant.imgBanana,
        title: "Banana\nchallenge",
      ),
      ChallengeItemModel(
        imageUrl: ImageConstant.imgCarrots,
        title: "Carrots\nchallenge",
      ),
    ],
    [
      ChallengeItemModel(
        imageUrl: ImageConstant.imgBerries,
        title: "Berries\nchallenge",
      ),
      ChallengeItemModel(
        imageUrl: ImageConstant.imgBroccoli,
        title: "Broccoli\nchallenge",
      ),
      ChallengeItemModel(
        imageUrl: ImageConstant.imgCabbage,
        title: "Cabbage\nchallenge",
      ),
    ],
  ];
}
