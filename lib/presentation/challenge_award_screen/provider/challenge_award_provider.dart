import 'package:flutter/material.dart';
import '../models/challenge_award_model.dart';

class ChallengeAwardProvider extends ChangeNotifier {
  late ChallengeAwardModel _challengeAwardModelObj;

  ChallengeAwardProvider({int awardIndex = 0}) {
    if (awardIndex == 0) {
      _challengeAwardModelObj = ChallengeAwardModel.goldenLadle();
    } else if (awardIndex == 1) {
      _challengeAwardModelObj = ChallengeAwardModel.sugarFree();
    } else if (awardIndex == 2) {
      _challengeAwardModelObj = ChallengeAwardModel.goldenApple();
    } else if (awardIndex == 3) {
      _challengeAwardModelObj = ChallengeAwardModel.halfWayThrough();
    } else if (awardIndex == 4) {
      _challengeAwardModelObj = ChallengeAwardModel.carnivoreChallenge();
    } else if (awardIndex == 5) {
      _challengeAwardModelObj = ChallengeAwardModel.avocadoExcellence();
    } else {
      _challengeAwardModelObj = ChallengeAwardModel.goldenLadle();
    }
  }

  ChallengeAwardModel get challengeAwardModelObj => _challengeAwardModelObj;
}