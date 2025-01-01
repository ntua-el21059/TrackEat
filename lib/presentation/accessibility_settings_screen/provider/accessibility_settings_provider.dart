import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/accessibility_settings_model.dart';
import '../../../theme/theme_provider.dart' as app_theme;
import 'package:provider/provider.dart';
import 'dart:io';

class AccessibilitySettingsProvider extends ChangeNotifier {
  AccessibilitySettingsModel _model = AccessibilitySettingsModel();
  static const platform = MethodChannel('com.trackeat.app/accessibility');

  // Initialize the provider with current theme settings
  void initializeSettings(BuildContext context) async {
    final themeProvider = Provider.of<app_theme.ThemeProvider>(context, listen: false);
    _model.invertColors = themeProvider.invertColors;
    _model.largerText = themeProvider.largerText;
    
    if (Platform.isIOS) {
      try {
        final bool isEnabled = await platform.invokeMethod('isVoiceAssistantEnabled');
        _model.voiceOver = isEnabled;
      } catch (e) {
        print('Failed to get VoiceOver status: $e');
      }
    }
    
    notifyListeners();
  }

  bool get voiceOver => _model.voiceOver;
  bool get invertColors => _model.invertColors;
  bool get largerText => _model.largerText;

  Future<void> toggleVoiceOver() async {
    if (Platform.isIOS) {
      try {
        final bool success = await platform.invokeMethod('toggleVoiceOver');
        if (success) {
          _model.voiceOver = !_model.voiceOver;
          notifyListeners();
        }
      } catch (e) {
        print('Failed to toggle VoiceOver: $e');
      }
    }
  }

  void toggleInvertColors(BuildContext context) {
    _model.invertColors = !_model.invertColors;
    Provider.of<app_theme.ThemeProvider>(context, listen: false)
        .toggleInvertColors(_model.invertColors);
    notifyListeners();
  }

  void toggleLargerText(BuildContext context) {
    _model.largerText = !_model.largerText;
    Provider.of<app_theme.ThemeProvider>(context, listen: false)
        .toggleLargerText(_model.largerText);
    notifyListeners();
  }
}