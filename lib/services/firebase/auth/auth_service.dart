import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Email and Password Sign Up
  Future<UserCredential> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      if (userCredential.user == null) {
        throw Exception('Failed to create user: No user data returned');
      }
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Sign Up Error Code: ${e.code}');
      print('Sign Up Error Message: ${e.message}');
      rethrow;
    } catch (e) {
      print('Sign Up Error: $e');
      rethrow;
    }
  }

  // Email and Password Sign In
  Future<UserCredential> signIn(String email, String password) async {
    try {
      // Configure reCAPTCHA
      await _auth.setSettings(
        appVerificationDisabledForTesting: false, // Enable reCAPTCHA
      );
      
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      if (userCredential.user == null) {
        throw Exception('Failed to sign in: No user data returned');
      }
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Sign In Error Code: ${e.code}');
      print('Sign In Error Message: ${e.message}');
      rethrow;
    } catch (e) {
      print('Sign In Error: $e');
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign Out Error: $e');
      rethrow;
    }
  }

  // Password Reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('Password Reset Error Code: ${e.code}');
      print('Password Reset Error Message: ${e.message}');
      rethrow;
    } catch (e) {
      print('Password Reset Error: $e');
      rethrow;
    }
  }
} 