import 'package:flutter/material.dart';
import '../models/challenge_award_model.dart';
import '../../../models/award_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeAwardProvider extends ChangeNotifier {
  final Award award;
  ChallengeAwardModel challengeAwardModelObj;
  bool isLoading = true;

  ChallengeAwardProvider({
    required this.award,
  }) : challengeAwardModelObj = ChallengeAwardModel(
        imagePath: award.picture,
        title: award.name,
        earnedDate: award.awarded is Timestamp 
            ? (award.awarded as Timestamp).toDate()
            : (award.awarded is String 
                ? DateTime.parse(award.awarded as String)
                : DateTime.now()),
        description: award.description,
      ) {
    _initializeAward();
  }

  Future<void> _initializeAward() async {
    try {
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error initializing award: $e');
      isLoading = false;
      notifyListeners();
    }
  }
}