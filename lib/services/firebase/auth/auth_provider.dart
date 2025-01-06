import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firestore/firestore_service.dart';
import '../../../models/user_model.dart';
import 'auth_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_info_provider.dart';
import '../../../presentation/signup_login/login_screen/provider/login_provider.dart';
import '../../../services/points_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PointsService _pointsService = PointsService();

  User? _user;
  String? _lastError;
  UserModel? _userData;

  User? get user => _user;
  String? get lastError => _lastError;
  bool get isAuthenticated => _user != null;
  UserModel? get userData => _userData;

  set userData(UserModel? value) {
    _userData = value;
    notifyListeners();
  }

  AuthProvider() {
    _user = _authService.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signIn(
      BuildContext context, String email, String password) async {
    try {
      final result = await _authService.signIn(email, password);
      _user = result.user;

      if (_user != null) {
        // Get user document from Firestore using email
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data()!;

          // Get all user data from Firestore document
          final firstName = userData['firstName'] ?? '';
          final lastName = userData['lastName'] ?? '';
          final username = userData['username'] ?? '';

          // Add one point for logging in
          await _pointsService.addLoginPoints();

          if (context.mounted) {
            final userInfoProvider =
                Provider.of<UserInfoProvider>(context, listen: false);

            // Update all values in the provider
            await userInfoProvider.updateName(
                firstName.toString(), lastName.toString());
            await userInfoProvider.updateUsername(username.toString());
            // Force UI update
            userInfoProvider.notifyListeners();
          }
        }

        _lastError = null;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _lastError = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      final result = await _authService.signUp(email, password);
      _user = result.user;

      final userModel = UserModel(
        email: email,
        username: email.split('@')[0],
      );

      await _firestoreService.createUser(userModel);

      _lastError = null;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _lastError = _getReadableError(e);
      notifyListeners();
      return false;
    } catch (e) {
      _lastError = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _authService.signOut();
      _user = null;
      _lastError = null;

      final userInfoProvider =
          Provider.of<UserInfoProvider>(context, listen: false);
      await userInfoProvider.clearUserInfo();

      // Clear login state from shared preferences
      await LoginProvider.clearLoginState();

      notifyListeners();
    } catch (e) {
      _lastError = e.toString();
      notifyListeners();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
      _lastError = null;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _lastError = _getReadableError(e);
      notifyListeners();
    } catch (e) {
      _lastError = e.toString();
      notifyListeners();
    }
  }

  String _getReadableError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password provided is too weak.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }

  Future<void> fetchUserData() async {
    try {
      final userDoc = await _firestore
          .collection('users')
          .doc(_auth.currentUser?.email)
          .get();

      if (userDoc.exists) {
        _userData = UserModel.fromJson(userDoc.data()!);

        if (_userData?.diet == null) {
          await updateUserDiet('Balanced');
          _userData = _userData?.copyWith(diet: 'Balanced');
        }

        notifyListeners();
      }
    } catch (e) {
      print('Error fetching user data: $e');
      rethrow;
    }
  }

  Future<void> updateUserDiet(String newDiet) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.email)
          .update({'diet': newDiet});

      _userData = _userData?.copyWith(diet: newDiet);
      notifyListeners();
    } catch (e) {
      print('Error updating diet: $e');
      rethrow;
    }
  }
}
