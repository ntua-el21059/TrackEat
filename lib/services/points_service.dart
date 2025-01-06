import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PointsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Point values for different actions
  static const int POINTS_LOGIN = 1;
  static const int POINTS_ADD_FRIEND = 10;
  static const int POINTS_REMOVE_FRIEND = -10;
  static const int POINTS_LOG_MEAL = 15;
  static const int POINTS_DELETE_MEAL = -15;

  // Generic method to add/subtract points
  Future<void> addPoints(int points) async {
    final currentUser = _auth.currentUser;
    if (currentUser?.email == null) return;

    try {
      final docRef = _firestore.collection('users').doc(currentUser!.email);

      // Get current points
      final doc = await docRef.get();
      if (!doc.exists) {
        throw Exception('User document not found');
      }

      final currentPoints = (doc.data()?['points'] as num?)?.toInt() ?? 0;
      final newPoints = currentPoints + points;

      // Update points in Firestore
      await docRef.update({'points': newPoints});
    } catch (e) {
      print('Error updating points: $e');
      rethrow;
    }
  }

  // Specific methods for each action
  Future<void> addLoginPoints() async {
    await addPoints(POINTS_LOGIN);
  }

  Future<void> addFriendPoints() async {
    await addPoints(POINTS_ADD_FRIEND);
  }

  Future<void> removeFriendPoints() async {
    await addPoints(POINTS_REMOVE_FRIEND);
  }

  Future<void> addMealPoints() async {
    await addPoints(POINTS_LOG_MEAL);
  }

  Future<void> removeMealPoints() async {
    await addPoints(POINTS_DELETE_MEAL);
  }

  // Reset points to zero
  Future<void> resetPoints() async {
    final currentUser = _auth.currentUser;
    if (currentUser?.email == null) return;

    try {
      final docRef = _firestore.collection('users').doc(currentUser!.email);
      await docRef.update({'points': 0});
    } catch (e) {
      print('Error resetting points: $e');
      rethrow;
    }
  }

  // Check and handle monthly reset
  Future<void> checkAndResetMonthlyPoints() async {
    final currentUser = _auth.currentUser;
    if (currentUser?.email == null) return;

    try {
      final docRef = _firestore.collection('users').doc(currentUser!.email);
      final doc = await docRef.get();

      if (!doc.exists) return;

      final data = doc.data() as Map<String, dynamic>;
      final lastResetDate = data['lastPointsReset'] as Timestamp?;
      final now = DateTime.now();

      // If no last reset date or it's a different month, reset points
      if (lastResetDate == null ||
          lastResetDate.toDate().month != now.month ||
          lastResetDate.toDate().year != now.year) {
        await resetPoints();
        await docRef.update({
          'lastPointsReset': Timestamp.now(),
        });
      }
    } catch (e) {
      print('Error checking monthly points reset: $e');
      rethrow;
    }
  }
}
