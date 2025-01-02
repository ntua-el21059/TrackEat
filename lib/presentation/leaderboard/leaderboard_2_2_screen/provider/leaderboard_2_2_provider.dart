import 'package:flutter/material.dart';
import '../../../../../core/app_export.dart';
import '../models/challenges2two_item_model.dart';
import '../models/leaderboard_2_2_model.dart';
import '../models/listfour_item_model.dart';

// Provider class that manages the state for the leaderboard screen, including
// the list of leaderboard entries and challenge items
class Leaderboard22Provider extends ChangeNotifier {
  // Main data model containing leaderboard and challenge lists
  Leaderboard22Model leaderboard22ModelObj = Leaderboard22Model();

  // Tracks current position in challenge carousel
  int sliderIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  // Updates slider position and notifies listeners to rebuild UI
  void changeSliderIndex(int value) {
    sliderIndex = value;
    notifyListeners();
  }
}
