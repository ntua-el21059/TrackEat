import '../../../core/app_export.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChallengeAwardModel {
  final String imagePath;
  final String title;
  final DateTime earnedDate;
  final String description;

  ChallengeAwardModel({
    required this.imagePath,
    required this.title,
    required this.earnedDate,
    required this.description,
  });

  String get formattedEarnedDate {
    return DateFormat('MMMM d, y').format(earnedDate);
  }
}