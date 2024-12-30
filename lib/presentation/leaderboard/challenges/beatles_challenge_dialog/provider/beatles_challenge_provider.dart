import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/beatles_challenge_model.dart';

/// A provider class for the BeatlesChallengeDialog.
///
/// This provider manages the state of the BeatlesChallengeDialog, including the
/// current beatlesChallengeModelObj
// ignore_for_file: must_be_immutable
class BeatlesChallengeProvider extends ChangeNotifier {
  // Initialize the model object for managing challenge-specific data
  BeatlesChallengeModel beatlesChallengeModelObj = BeatlesChallengeModel();

  @override
  void dispose() {
    super.dispose();
  }
}
