import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/social_profile_message_from_profile_model.dart';

/// A provider class for the SocialProfileMessageFromProfileScreen.
///
/// This provider manages the state of the SocialProfileMessageFromProfileScreen, 
/// including the current [socialProfileMessageFromProfileModelObj].
class SocialProfileMessageFromProfileProvider extends ChangeNotifier {
  // Controller for the text field
  TextEditingController messageOneController = TextEditingController();

  // The model object for managing state
  SocialProfileMessageFromProfileModel socialProfileMessageFromProfileModelObj =
      SocialProfileMessageFromProfileModel();

  @override
  void dispose() {
    messageOneController.dispose();
    super.dispose();
  }
}