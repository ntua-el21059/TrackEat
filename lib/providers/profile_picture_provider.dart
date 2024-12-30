import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePictureProvider extends ChangeNotifier {
  String _profileImagePath = 'assets/images/imgVector80x84.png';
  final SharedPreferences _prefs;

  ProfilePictureProvider(this._prefs) {
    _loadProfilePicture();
  }

  String get profileImagePath => _profileImagePath;

  Future<void> _loadProfilePicture() async {
    _profileImagePath = _prefs.getString('profile_picture_path') ?? 'assets/images/imgVector80x84.png';
    notifyListeners();
  }

  Future<void> updateProfilePicture(String newPath) async {
    _profileImagePath = newPath;
    await _prefs.setString('profile_picture_path', newPath);
    notifyListeners();
  }
} 