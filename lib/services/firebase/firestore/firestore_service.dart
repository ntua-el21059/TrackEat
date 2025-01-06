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
        // Calculate macronutrient goals based on user's daily calorie goal
        final dailyCalories = userData['dailyCalories'] as int? ?? 2000;

        // Calculate macros: 30% protein, 45% carbs, 25% fat
        userData['carbsgoal'] =
            ((0.45 * dailyCalories) / 4).round().toDouble(); // 45% of calories
        userData['proteingoal'] =
            ((0.30 * dailyCalories) / 4).round().toDouble(); // 30% of calories
        userData['fatgoal'] =
            ((0.25 * dailyCalories) / 9).round().toDouble(); // 25% of calories

        // Initialize points to 0 for new users
        userData['points'] = 0;

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
          carbsGoal: data['carbsgoal']?.toDouble(),
          proteinGoal: data['proteingoal']?.toDouble(),
          fatGoal: data['fatgoal']?.toDouble(),
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

  // Add points to a user
  Future<void> addPoints(String email, int pointsToAdd) async {
    try {
      final docRef = _firestore.collection('users').doc(email);

      // Get current points
      final doc = await docRef.get();
      if (!doc.exists) {
        throw Exception('User document not found');
      }

      final currentPoints = (doc.data()?['points'] as num?)?.toInt() ?? 0;
      final newPoints = currentPoints + pointsToAdd;

      // Update points in Firestore
      await docRef.update({'points': newPoints});
    } catch (e) {
      print('Error updating points: $e');
      rethrow;
    }
  }
}
