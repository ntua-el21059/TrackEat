import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../routes/app_routes.dart';
import '../../widgets/widgets.dart';
import 'welcome_screen.dart';

class WelcomeModel {}

/// A provider class for the WelcomeScreen.
///
/// This provider manages the state of the WelcomeScreen, including the
/// current welcomeModelObj
// ignore_for_file: must_be_immutable
class WelcomeProvider extends ChangeNotifier {
  WelcomeModel welcomeModelObj = WelcomeModel();

  @override
  void dispose() {
    super.dispose();
  }
}
