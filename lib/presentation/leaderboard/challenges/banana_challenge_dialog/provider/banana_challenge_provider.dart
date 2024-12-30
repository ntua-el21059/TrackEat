import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/banana_challenge_model.dart';

/// A provider class for the BananaChallengeDialog.
///
/// This provider manages the state of the BananaChallengeDialog, including the
/// current bananaChallengeModelObj
// ignore_for_file: must_be_immutable
class BananaChallengeProvider extends ChangeNotifier {
  // Initialize the model object that will hold the challenge state
  BananaChallengeModel bananaChallengeModelObj = BananaChallengeModel();

  @override
  void dispose() {
    super.dispose();
  }
}
