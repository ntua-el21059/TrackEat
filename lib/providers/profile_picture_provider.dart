import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ProfilePictureProvider extends ChangeNotifier {
  String _profileImagePath = 'assets/images/imgVector80x84.png';
  final SharedPreferences _prefs;

  ProfilePictureProvider(this._prefs) {
    _loadProfilePicture();
  }

  String get profileImagePath => _profileImagePath;

  Future<void> _loadProfilePicture() async {
    final savedPath = _prefs.getString('profile_picture_path');
    if (savedPath != null && File(savedPath).existsSync()) {
      _profileImagePath = savedPath;
    } else {
      _profileImagePath = 'assets/images/imgVector80x84.png';
    }
    notifyListeners();
  }

  Future<void> updateProfilePicture(String imagePath) async {
    try {
      // Crop the image
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
          ),
        ],
      );

      if (croppedFile != null) {
        // Get the app's local directory
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'profile_picture_${DateTime.now().millisecondsSinceEpoch}${path.extension(croppedFile.path)}';
        final localPath = path.join(appDir.path, fileName);

        // Copy the cropped image to local storage
        await File(croppedFile.path).copy(localPath);

        // Delete old profile picture if it exists and is not the default one
        if (_profileImagePath != 'assets/images/imgVector80x84.png' && File(_profileImagePath).existsSync()) {
          await File(_profileImagePath).delete();
        }

        // Update the path and save it
        _profileImagePath = localPath;
        await _prefs.setString('profile_picture_path', localPath);
        notifyListeners();
      }
    } catch (e) {
      print('Error updating profile picture: $e');
    }
  }
} 