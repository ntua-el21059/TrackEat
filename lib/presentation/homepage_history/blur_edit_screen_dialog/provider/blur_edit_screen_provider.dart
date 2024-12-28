import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/blur_edit_item_model.dart';
import '../models/blur_edit_screen_model.dart';

/// A provider class for the BlurEditScreenDialog.
///
/// This provider manages the state of the BlurEditScreenDialog, including the
/// current blurEditScreenModelObj
// ignore_for_file: must_be_immutable
class BlurEditScreenProvider extends ChangeNotifier {
  BlurEditScreenModel blurEditScreenModelObj = BlurEditScreenModel();

  @override
  void dispose() {
    super.dispose();
  }
}
