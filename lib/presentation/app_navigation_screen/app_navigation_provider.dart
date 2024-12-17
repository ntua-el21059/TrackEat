import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../routes/app_routes.dart';
import '../../widgets/widgets.dart';
import 'app_navigation_screen.dart';

class AppNavigationModel {}

/// A provider class for the AppNavigationScreen.
///
/// This provider manages the state of the AppNavigationScreen, including the
/// current appNavigationModelObj.
// ignore_for_file: must_be_immutable
class AppNavigationProvider extends ChangeNotifier {
  AppNavigationModel appNavigationModelObj = AppNavigationModel();

  @override
  void dispose() {
    super.dispose();
  }
}