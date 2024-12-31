import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal.dart';

class MealService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'meals';

  // Add a new meal
  Future<String> addMeal(Meal meal) async {
    try {
      final docRef = await _firestore.collection(_collection).add(meal.toMap());
      return docRef.id;
    } catch (e) {
      print('Error adding meal: $e');
      throw e;
    }
  }

  // Get meals for a specific user and date
  Stream<List<Meal>> getMealsByUserAndDate(String userId, DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThan: endOfDay)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Meal.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  // Delete a meal
  Future<void> deleteMeal(String mealId) async {
    try {
      await _firestore.collection(_collection).doc(mealId).delete();
    } catch (e) {
      print('Error deleting meal: $e');
      throw e;
    }
  }

  // Update a meal
  Future<void> updateMeal(Meal meal) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(meal.id)
          .update(meal.toMap());
    } catch (e) {
      print('Error updating meal: $e');
      throw e;
    }
  }

  // Get total calories for a user on a specific date
  Future<int> getTotalCaloriesForDate(String userId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .get();

      int totalCalories = 0;
      for (var doc in querySnapshot.docs) {
        totalCalories += (doc.data()['calories'] as int);
      }
      return totalCalories;
    } catch (e) {
      print('Error getting total calories: $e');
      throw e;
    }
  }

  // Get total macros for a user on a specific date
  Future<Map<String, double>> getTotalMacrosForDate(String userId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(Duration(days: 1));

    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .get();

      Map<String, double> totalMacros = {
        'protein': 0.0,
        'fats': 0.0,
        'carbs': 0.0,
      };

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> macros = doc.data()['macros'];
        totalMacros['protein'] = (totalMacros['protein'] ?? 0) + (macros['protein'] ?? 0);
        totalMacros['fats'] = (totalMacros['fats'] ?? 0) + (macros['fats'] ?? 0);
        totalMacros['carbs'] = (totalMacros['carbs'] ?? 0) + (macros['carbs'] ?? 0);
      }
      return totalMacros;
    } catch (e) {
      print('Error getting total macros: $e');
      throw e;
    }
  }
} 