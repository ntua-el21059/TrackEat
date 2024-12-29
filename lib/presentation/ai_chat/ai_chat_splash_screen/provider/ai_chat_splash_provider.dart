import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/ai_chat_splash_model.dart';

/// A provider class for the AiChatSplashScreen.
///
/// This provider manages the state of the AiChatSplashScreen, including the
/// current aiChatSplashModelObj.
// ignore_for_file: must_be_immutable
class AiChatSplashProvider extends ChangeNotifier {
  AiChatSplashModel aiChatSplashModelObj = AiChatSplashModel();

  @override
  void dispose() {
    super.dispose();
  }
}