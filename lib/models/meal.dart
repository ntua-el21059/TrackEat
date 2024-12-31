import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  final String id;
  final String userEmail;
  final String name;
  final String mealType; // breakfast, lunch, or dinner
  final int calories;
  final double servingSize;
  final Map<String, double> macros; // protein, fats, carbs
  final DateTime date;

  Meal({
    required this.id,
    required this.userEmail,
    required this.name,
    required this.mealType,
    required this.calories,
    required this.servingSize,
    required this.macros,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userEmail': userEmail,
      'name': name,
      'mealType': mealType,
      'calories': calories,
      'servingSize': servingSize,
      'macros': macros,
      'date': date,
    };
  }

  static Meal fromMap(Map<String, dynamic> map, String documentId) {
    return Meal(
      id: documentId,
      userEmail: map['userEmail'],
      name: map['name'],
      mealType: map['mealType'],
      calories: map['calories'],
      servingSize: map['servingSize'],
      macros: Map<String, double>.from(map['macros']),
      date: (map['date'] as Timestamp).toDate(),
    );
  }
} 