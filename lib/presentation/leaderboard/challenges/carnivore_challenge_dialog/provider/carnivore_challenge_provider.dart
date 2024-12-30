import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/carnivore_challenge_model.dart';

/// A provider class for the CarnivoreChallengeDialog.
///
/// This provider manages the state of the CarnivoreChallengeDialog, including the
/// current carnivoreChallengeModelObj
// ignore_for_file: must_be_immutable
class CarnivoreChallengeProvider extends ChangeNotifier {
  // Initialize the model object for managing challenge state
  CarnivoreChallengeModel carnivoreChallengeModelObj =
      CarnivoreChallengeModel();

  @override
  void dispose() {
    super.dispose();
  }
}
