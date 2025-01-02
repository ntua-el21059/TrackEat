import 'package:flutter/material.dart';
import '../../../../../core/app_export.dart';
import '../models/leaderboard_1_2_model.dart';
import '../models/challenges1two_item_model.dart';

/// A provider class for the Leaderboard12Screen.
///
/// This provider manages the state of the Leaderboard12Screen, including the
/// current leaderboard12ModelObj
// ignore_for_file: must_be_immutable
class LeaderboardProvider extends ChangeNotifier {
  LeaderboardModel leaderboardModelObj = LeaderboardModel();

  int sliderIndex = 0;

  // Number of challenges to show per page
  final int challengesPerPage = 3;

  @override
  void dispose() {
    super.dispose();
  }

  void changeSliderIndex(int value) {
    sliderIndex = value;
    notifyListeners();
  }

  // Get total number of pages based on challenges list length
  int get totalPages {
    return (leaderboardModelObj.challengesList.length / challengesPerPage)
        .ceil();
  }

  // Get challenges for current page
  List<Challenges1twoItemModel> getCurrentPageChallenges() {
    final startIndex = sliderIndex * challengesPerPage;
    final endIndex = startIndex + challengesPerPage;
    return leaderboardModelObj.challengesList.sublist(
      startIndex,
      endIndex.clamp(0, leaderboardModelObj.challengesList.length),
    );
  }
}
