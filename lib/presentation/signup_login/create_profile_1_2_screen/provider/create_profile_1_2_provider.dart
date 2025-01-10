import 'package:flutter/material.dart';
import '../models/create_profile_1_2_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

/// A provider class for the CreateProfile12Screen.
///
/// This provider manages the state of the CreateProfile12Screen, including the
/// current createProfile12ModelObj.
// ignore_for_file: must_be_immutable
class CreateProfile12Provider extends ChangeNotifier {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController gendertwoController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  CreateProfile12Model createProfile12ModelObj = CreateProfile12Model();

  String? usernameError;
  String? emailError;
  Timer? _debounceTimer;

  CreateProfile12Provider() {
    firstNameController.addListener(_textChanged);
    lastNameController.addListener(_textChanged);
    dateController.addListener(_textChanged);
    gendertwoController.addListener(_textChanged);
    usernameController.addListener(_onUsernameChanged);
    emailController.addListener(_onEmailChanged);
  }

  void _textChanged() {
    notifyListeners();
  }

  void _onUsernameChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      validateUsername(usernameController.text);
    });
    notifyListeners();
  }

  void _onEmailChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      validateEmail(emailController.text);
    });
    notifyListeners();
  }

  Future<void> validateUsername(String username) async {
    print('Starting username validation for: $username');
    if (username.isEmpty) {
      print('Username is empty, clearing error');
      usernameError = null;
      notifyListeners();
      return;
    }

    try {
      print('Querying Firestore for username: ${username.trim()}');
      final usernameQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username.trim())
          .get();

      print('Firestore query completed');
      print('Found documents: ${usernameQuery.docs.length}');
      print('Documents data: ${usernameQuery.docs.map((doc) => doc.data())}');

      if (usernameQuery.docs.isNotEmpty) {
        print('Username exists, setting error');
        usernameError = 'This username already exists';
      } else {
        print('Username is available, clearing error');
        usernameError = null;
      }
      print('Current usernameError value: $usernameError');
      notifyListeners();
    } catch (e) {
      print('Error validating username: $e');
      print('Error stack trace: ${StackTrace.current}');
    }
  }

  Future<void> validateEmail(String email) async {
    if (email.isEmpty) {
      emailError = null;
      notifyListeners();
      return;
    }

    try {
      final emailQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email.trim().toLowerCase())
          .get();

      print('Checking email: ${email.trim().toLowerCase()}');
      print('Found documents: ${emailQuery.docs.length}');

      if (emailQuery.docs.isNotEmpty) {
        emailError = 'This email is already registered';
      } else {
        emailError = null;
      }
      notifyListeners();
    } catch (e) {
      print('Error validating email: $e');
    }
  }

  void clearErrors() {
    usernameError = null;
    emailError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    firstNameController.removeListener(_textChanged);
    lastNameController.removeListener(_textChanged);
    dateController.removeListener(_textChanged);
    gendertwoController.removeListener(_textChanged);
    usernameController.removeListener(_onUsernameChanged);
    emailController.removeListener(_onEmailChanged);
    firstNameController.dispose();
    lastNameController.dispose();
    dateController.dispose();
    gendertwoController.dispose();
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}