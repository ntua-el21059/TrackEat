import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      print('Attempting to save user to Firestore with email: ${user.email}');
      print('User data to save: ${user.toJson()}');
      
      if (user.email == null) {
        throw Exception('Cannot create user document: email is null');
      }

      // First try to get the collection to verify Firestore connection
      final collection = _firestore.collection('users');
      print('Successfully accessed users collection');

      // Create the document reference
      final docRef = collection.doc(user.email);
      print('Created document reference for user: ${user.email}');

      // Convert user data to JSON
      final userData = user.toJson();
      print('Converted user data to JSON: $userData');

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
        print('Successfully updated user data in Firestore');
      } else {
        // Set the document data for new users
        await docRef.set(userData);
        print('Successfully created new user in Firestore');
      }
    } on FirebaseException catch (e) {
      print('Firestore Error Code: ${e.code}');
      print('Firestore Error Message: ${e.message}');
      print('Firestore Error Stack: ${e.stackTrace}');
      rethrow;
    } catch (e, stackTrace) {
      print('Error creating user in Firestore: $e');
      print('Error Stack Trace: $stackTrace');
      rethrow;
    }
  }

  Future<UserModel?> getUser(String email) async {
    try {
      print('Attempting to fetch user from Firestore with email: $email');
      
      // First try to get the collection
      final collection = _firestore.collection('users');
      print('Successfully accessed users collection');

      // Get the document
      final doc = await collection.doc(email).get();
      print('Successfully retrieved document snapshot');
      
      if (doc.exists) {
        print('User document found in Firestore');
        final data = doc.data() as Map<String, dynamic>;
        print('User data from Firestore: $data');
        
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
      print('No user document found in Firestore for email: $email');
      return null;
    } on FirebaseException catch (e) {
      print('Firestore Error Code: ${e.code}');
      print('Firestore Error Message: ${e.message}');
      print('Firestore Error Stack: ${e.stackTrace}');
      rethrow;
    } catch (e, stackTrace) {
      print('Error getting user from Firestore: $e');
      print('Error Stack Trace: $stackTrace');
      rethrow;
    }
  }

  // Test Firestore connection
  Future<bool> testConnection() async {
    try {
      print('Testing Firestore connection...');
      final collection = _firestore.collection('users');
      await collection.limit(1).get();
      print('Firestore connection test successful');
      return true;
    } catch (e) {
      print('Firestore connection test failed: $e');
      return false;
    }
  }
}