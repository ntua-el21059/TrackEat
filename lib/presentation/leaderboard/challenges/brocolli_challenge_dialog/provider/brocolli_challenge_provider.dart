import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/brocolli_challenge_model.dart';

/// A provider class for the BrocolliChallengeDialog.
///
/// This provider manages the state of the BrocolliChallengeDialog, including the
/// current brocolliChallengeModelObj
// ignore_for_file: must_be_immutable
class BrocolliChallengeProvider extends ChangeNotifier {
  // Initialize the model object that holds the challenge-specific data
  BrocolliChallengeModel brocolliChallengeModelObj = BrocolliChallengeModel();

  @override
  void dispose() {
    super.dispose();
  }
}
