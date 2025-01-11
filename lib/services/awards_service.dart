import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/award_model.dart';

class AwardsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all awards for a specific user with real-time updates
  Stream<List<Award>> getUserAwardsStream(String userId) {
    try {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('awards')
          .snapshots()
          .map((snapshot) {
            try {
              return snapshot.docs.map((doc) {
                try {
                  final data = doc.data();
                  data['id'] = doc.id; // Ensure the document ID is included
                  return Award.fromMap(data);
                } catch (e) {
                  print('Error parsing award document ${doc.id}: $e');
                  return null;
                }
              })
              .where((award) => award != null)
              .cast<Award>()
              .toList();
            } catch (e) {
              print('Error processing awards snapshot: $e');
              return <Award>[];
            }
          });
    } catch (e) {
      print('Error creating awards stream: $e');
      return Stream.value(<Award>[]);
    }
  }

  // Add or update an award to a user
  Future<void> addOrUpdateAward(String userId, Award award) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('awards')
          .doc(award.id)
          .set(award.toMap());
    } catch (e) {
      print('Error adding/updating award: $e');
      throw e;
    }
  }

  // Update award status (awarded/not awarded)
  Future<void> updateAwardStatus(String userId, String awardId, bool isAwarded) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('awards')
          .doc(awardId)
          .update({'isAwarded': isAwarded});
    } catch (e) {
      print('Error updating award status: $e');
      throw e;
    }
  }

  // Get a specific award
  Future<Award?> getAward(String userId, String awardId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('awards')
          .doc(awardId)
          .get();
      
      if (!doc.exists) return null;
      
      final data = doc.data()!;
      data['id'] = doc.id; // Ensure the document ID is included
      return Award.fromMap(data);
    } catch (e) {
      print('Error getting award: $e');
      return null;
    }
  }

  // Delete an award
  Future<void> deleteAward(String userId, String awardId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('awards')
          .doc(awardId)
          .delete();
    } catch (e) {
      print('Error deleting award: $e');
      throw e;
    }
  }
} 