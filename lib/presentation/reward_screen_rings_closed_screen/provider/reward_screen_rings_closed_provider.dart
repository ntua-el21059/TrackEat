import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/reward_screen_rings_closed_model.dart';

/// A provider class for the RewardScreenRingsClosedScreen.
///
/// This provider manages the state of the RewardScreenRingsClosedScreen, 
/// including the current rewardScreenRingsClosedModelObj.
// ignore_for_file: must_be_immutable
class RewardScreenRingsClosedProvider extends ChangeNotifier {
  RewardScreenRingsClosedModel rewardScreenRingsClosedModelObj =
      RewardScreenRingsClosedModel();

  @override
  void dispose() {
    super.dispose();
  }
}
