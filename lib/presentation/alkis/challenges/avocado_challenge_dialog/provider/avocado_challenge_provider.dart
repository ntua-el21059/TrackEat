import 'package:flutter/material.dart';
import '../../../../../core/app_export.dart';
import '../models/avocado_challenge_model.dart';

/// A provider class for the AvocadoChallengeDialog.
///
/// This provider manages the state of the AvocadoChallengeDialog, including the
/// current avocadoChallengeModelObj
// ignore_for_file: must_be_immutable
class AvocadoChallengeProvider extends ChangeNotifier {
  AvocadoChallengeModel avocadoChallengeModelObj = AvocadoChallengeModel();

  @override
  void dispose() {
    super.dispose();
  }
}
