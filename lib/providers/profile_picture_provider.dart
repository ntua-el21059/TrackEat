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

  Future<bool> updateProfilePicture(String imagePath) async {
    try {
      // Crop the image
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        cropStyle: CropStyle.circle,
        compressFormat: ImageCompressFormat.png,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            showCropGrid: true,
            hideBottomControls: false,
            cropFrameColor: Colors.blue,
            cropGridColor: Colors.blue,
            activeControlsWidgetColor: Colors.blue,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
            rotateButtonsHidden: false,
            resetButtonHidden: false,
            aspectRatioLockDimensionSwapEnabled: false,
            showActivitySheetOnDone: false,
            showCancelConfirmationDialog: true,
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
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating profile picture: $e');
      return false;
    }
  }
} 