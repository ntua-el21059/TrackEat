import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/wrap_challenge_model.dart';

/// A provider class for the WrapChallengeDialog.
///
/// This provider manages the state of the WrapChallengeDialog, including the
/// current wrapChallengeModelObj
// ignore_for_file: must_be_immutable
class WrapChallengeProvider extends ChangeNotifier {
  // Initialize the model object for storing challenge-related data
  WrapChallengeModel wrapChallengeModelObj = WrapChallengeModel();

  @override
  void dispose() {
    super.dispose();
  }
}
