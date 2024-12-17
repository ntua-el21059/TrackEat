import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../routes/app_routes.dart';
import '../../widgets/widgets.dart';
import 'create_profile_2_2_screen.dart';

class CreateProfile22Model {}

/// A provider class for the CreateProfile22Screen.
///
/// This provider manages the state of the CreateProfile22Screen, including the
/// current createProfile22ModelObj
// ignore_for_file: must_be_immutable
class CreateProfile22Provider extends ChangeNotifier {
  TextEditingController activityInputController = TextEditingController();
  TextEditingController dietInputController = TextEditingController();
  TextEditingController goalInputController = TextEditingController();
  TextEditingController heightInputController = TextEditingController();
  TextEditingController weightInputController = TextEditingController();

  CreateProfile22Model createProfile22ModelObj = CreateProfile22Model();

  @override
  void dispose() {
    super.dispose();
    activityInputController.dispose();
    dietInputController.dispose();
    goalInputController.dispose();
    heightInputController.dispose();
    weightInputController.dispose();
  }
}
