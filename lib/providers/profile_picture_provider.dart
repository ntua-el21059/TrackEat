import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePictureProvider extends ChangeNotifier {
  String _profileImagePath = 'assets/images/person.crop.circle.fill.svg';
  String? _cachedProfilePicture;
  final SharedPreferences _prefs;
  StreamSubscription<DocumentSnapshot>? _firestoreSubscription;

  ProfilePictureProvider(this._prefs) {
    _loadProfilePicture();
    _setupFirestoreListener();
  }

  String get profileImagePath => _profileImagePath;
  String? get cachedProfilePicture => _cachedProfilePicture;

  Future<void> clearCache() async {
    // Cancel the Firestore subscription
    await _firestoreSubscription?.cancel();
    _firestoreSubscription = null;

    // Delete the local file if it exists and is not the default one
    if (_profileImagePath != 'assets/images/person.crop.circle.fill.svg' && File(_profileImagePath).existsSync()) {
      try {
        await File(_profileImagePath).delete();
      } catch (e) {
        print('Error deleting profile picture file: $e');
      }
    }

    // Clear the shared preferences
    await _prefs.remove('profile_picture_path');

    // Reset the paths and cache
    _profileImagePath = 'assets/images/person.crop.circle.fill.svg';
    _cachedProfilePicture = null;

    // Clear the app's cache directory of any profile pictures
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final files = Directory(appDir.path).listSync();
      for (var file in files) {
        if (file is File && file.path.contains('profile_picture_')) {
          await file.delete();
        }
      }
    } catch (e) {
      print('Error clearing profile picture cache directory: $e');
    }

    notifyListeners();
  }

  Future<void> _loadProfilePicture() async {
    final savedPath = _prefs.getString('profile_picture_path');
    if (savedPath != null && File(savedPath).existsSync()) {
      _profileImagePath = savedPath;
    } else {
      _profileImagePath = 'assets/images/person.crop.circle.fill.svg';
    }

    // Load initial profile picture from Firebase
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.email)
            .get();
        
        if (doc.exists) {
          final userData = doc.data()!;
          final newProfilePicture = userData['profilePicture'] as String?;
          if (newProfilePicture != _cachedProfilePicture) {
            _cachedProfilePicture = newProfilePicture;
            notifyListeners();
          }
        }
      } catch (e) {
        print('Error loading initial profile picture: $e');
      }
    }
  }

  void _setupFirestoreListener() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      _firestoreSubscription?.cancel();
      _firestoreSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.email)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          final userData = snapshot.data()!;
          final newProfilePicture = userData['profilePicture'] as String?;
          
          // Only update and notify if the profile picture has actually changed
          if (newProfilePicture != _cachedProfilePicture) {
            _cachedProfilePicture = newProfilePicture;
            notifyListeners();
          }
        }
      }, onError: (error) {
        print('Error in Firestore listener: $error');
      });
    }
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
        if (_profileImagePath != 'assets/images/person.crop.circle.fill.svg' && File(_profileImagePath).existsSync()) {
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

  @override
  void dispose() {
    _firestoreSubscription?.cancel();
    super.dispose();
  }
} 