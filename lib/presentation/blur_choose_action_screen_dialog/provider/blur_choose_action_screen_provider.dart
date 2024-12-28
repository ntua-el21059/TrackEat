import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/blur_choose_action_screen_model.dart';

/// A provider class for the BlurChooseActionScreenDialog.
///
/// This provider manages the state of the BlurChooseActionScreenDialog, including the
/// current blurChooseActionScreenModelObj
/// ignore_for_file: must_be_immutable
class BlurChooseActionScreenProvider extends ChangeNotifier {
  BlurChooseActionScreenModel blurChooseActionScreenModelObj = BlurChooseActionScreenModel();

  @override
  void dispose() {
    super.dispose();
  }
}
