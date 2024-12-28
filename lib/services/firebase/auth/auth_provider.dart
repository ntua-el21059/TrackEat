import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firestore/firestore_service.dart';
import '../../../models/user_model.dart';
import 'auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  User? _user;
  String? _lastError;

  User? get user => _user;
  String? get lastError => _lastError;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _user = _authService.currentUser;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signIn(String email, String password) async {
    try {
      final result = await _authService.signIn(email, password);
      _user = result.user;
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

  Future<bool> signUp(String email, String password) async {
    try {
      final result = await _authService.signUp(email, password);
      _user = result.user;
      
      // Create initial user document in Firestore
      final userModel = UserModel(
        email: email,
        username: email.split('@')[0], // Default username from email
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

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _user = null;
      _lastError = null;
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
} 