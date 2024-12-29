import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/ai_chat_main_page_model.dart';

/// A provider class for the AiChatMainScreen.
///
/// This provider manages the state of the AiChatMainScreen, including the
/// current aiChatMainModelObj.
// ignore_for_file: must_be_immutable
class AiChatMainProvider extends ChangeNotifier {
  TextEditingController messageController = TextEditingController();
  AiChatMainModel aiChatMainModelObj = AiChatMainModel();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}