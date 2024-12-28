import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/finalized_account_model.dart';

/// A provider class for the FinalizedAccountScreen.
///
/// This provider manages the state of the FinalizedAccountScreen, including the
/// current finalizedAccountModelObj
// ignore_for_file: must_be_immutable
class FinalizedAccountProvider extends ChangeNotifier {
  FinalizedAccountModel finalizedAccountModelObj = FinalizedAccountModel();

  @override
  void dispose() {
    super.dispose();
  }
}
