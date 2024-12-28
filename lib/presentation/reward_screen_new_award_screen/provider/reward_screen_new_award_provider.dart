import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/reward_screen_new_award_model.dart';

/// A provider class for the RewardScreenNewAwardScreen.
///
/// This provider manages the state of the RewardScreenNewAwardScreen, including the
/// current rewardScreenNewAwardModelObj
// ignore_for_file: must_be_immutable
class RewardScreenNewAwardProvider extends ChangeNotifier {
  RewardScreenNewAwardModel rewardScreenNewAwardModelObj = RewardScreenNewAwardModel();

  @override
  void dispose() {
    super.dispose();
  }
}
