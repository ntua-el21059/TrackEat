import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/challenges1two_item_model.dart';
import '../models/leaderboard_1_2_model.dart';
import '../models/listfour_item_model.dart';

/// A provider class for the Leaderboard12Screen.
///
/// This provider manages the state of the Leaderboard12Screen, including the
/// current leaderboard12ModelObj
// ignore_for_file: must_be_immutable
class Leaderboard12Provider extends ChangeNotifier {
  Leaderboard12Model leaderboard12ModelObj = Leaderboard12Model();

  int sliderIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  void changeSliderIndex(int value) {
    sliderIndex = value;
    notifyListeners();
  }
}
