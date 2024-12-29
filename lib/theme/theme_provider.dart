import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _invertColors = false;
  bool _largerText = false;

  bool get invertColors => _invertColors;
  bool get largerText => _largerText;
  double get textScaleFactor => _largerText ? 1.2 : 1.0;  // 20% larger when enabled

  void toggleInvertColors(bool value) {
    _invertColors = value;
    notifyListeners();
  }

  void toggleLargerText(bool value) {
    _largerText = value;
    notifyListeners();
  }

  Color invertColor(Color color) {
    if (!_invertColors) return color;
    
    return Color.fromARGB(
      color.alpha,
      255 - color.red,
      255 - color.green,
      255 - color.blue,
    );
  }
} 