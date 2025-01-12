import 'package:flutter/material.dart';

/// A provider class for the RewardScreenNewAwardScreen.
///
/// This provider manages the state of the RewardScreenNewAwardScreen, including the
/// current rewardScreenNewAwardModelObj
// ignore_for_file: must_be_immutable
class RewardScreenNewAwardProvider extends ChangeNotifier {
  final String awardId;
  final String awardName;
  final String awardDescription;
  final String awardPicture;
  final int awardPoints;
  final DateTime awardedTime;

  RewardScreenNewAwardProvider({
    required this.awardId,
    required this.awardName,
    required this.awardDescription,
    required this.awardPicture,
    required this.awardPoints,
    required this.awardedTime,
  });

  @override
  void dispose() {
    super.dispose();
  }
}
