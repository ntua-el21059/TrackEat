import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      if (user.email == null) {
        throw Exception('Cannot create user document: email is null');
      }

      final collection = _firestore.collection('users');
      final docRef = collection.doc(user.email);
      final userData = user.toJson();

      // Check if document exists
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        // Update only the non-null fields
        final Map<String, dynamic> updateData = {};
        userData.forEach((key, value) {
          if (value != null) {
            updateData[key] = value;
          }
        });
        await docRef.update(updateData);
      } else {
        // Set the document data for new users
        await docRef.set(userData);
      }
    } on FirebaseException catch (e) {
      print('Firestore Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error creating user in Firestore: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUser(String email) async {
    try {
      final doc = await _firestore.collection('users').doc(email).get();
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel(
          username: data['username'],
          email: data['email'],
          firstName: data['firstName'],
          lastName: data['lastName'],
          birthdate: data['birthdate'],
          gender: data['gender'],
          activity: data['activity'],
          diet: data['diet'],
          goal: data['goal'],
          height: data['height']?.toDouble(),
          weight: data['weight']?.toDouble(),
          dailyCalories: data['dailyCalories'],
        );
      }
      return null;
    } catch (e) {
      print('Error getting user from Firestore: $e');
      rethrow;
    }
  }

  // Test Firestore connection
  Future<bool> testConnection() async {
    try {
      await _firestore.collection('users').limit(1).get();
      return true;
    } catch (e) {
      print('Firestore connection test failed: $e');
      return false;
    }
  }
}