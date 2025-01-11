import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/award_model.dart';

class AwardsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all awards for a specific user with real-time updates
  Stream<List<Award>> getUserAwardsStream(String userId) {
    print('Getting awards stream for user: $userId');
    if (userId.isEmpty) {
      print('Error: userId is empty');
      return Stream.value([]);
    }

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      print('Current authenticated user: ${currentUser?.email}');
      
      if (currentUser == null || currentUser.email == null) {
        print('No authenticated user found');
        return Stream.value([]);
      }

      // Only initialize awards if viewing current user's profile
      if (currentUser.email == userId) {
        _ensureAwardsCollection(userId);
      }

      final userPath = 'users/$userId';
      final awardsPath = '$userPath/awards';
      print('Attempting to access Firestore path: $awardsPath');

      return _firestore
          .collection('users')
          .doc(userId)
          .collection('awards')
          .snapshots()
          .map((snapshot) {
            try {
              print('Got snapshot with ${snapshot.docs.length} awards');
              if (snapshot.docs.isEmpty) {
                print('No awards found in snapshot');
                return <Award>[];
              }

              final awards = snapshot.docs.map((doc) {
                try {
                  final data = doc.data();
                  print('Processing award document ${doc.id}');
                  data['id'] = doc.id;
                  final award = Award.fromMap(data);
                  print('Successfully created award: ${award.name}');
                  return award;
                } catch (e) {
                  print('Error parsing award document ${doc.id}: $e');
                  return null;
                }
              })
              .where((award) => award != null)
              .cast<Award>()
              .toList();
              
              print('Processed ${awards.length} awards successfully');
              return awards;
            } catch (e) {
              print('Error processing awards snapshot: $e');
              return <Award>[];
            }
          })
          .handleError((error) {
            print('Error in awards stream: $error');
            print('Error stack trace: $error');
            return <Award>[];
          });
    } catch (e) {
      print('Error creating awards stream: $e');
      return Stream.value(<Award>[]);
    }
  }

  // Ensure the awards collection exists and has default awards
  Future<void> _ensureAwardsCollection(String userId) async {
    try {
      final awardsRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('awards');

      final snapshot = await awardsRef.get();
      if (snapshot.docs.isEmpty) {
        print('Initializing default awards for user: $userId');
        // Add default awards
        final defaultAwards = [
          Award(
            id: '1',
            name: 'First Steps',
            points: 10,
            description: 'Started your fitness journey',
            picture: 'assets/images/award1.png',
            isAwarded: true,
            awarded: FieldValue.serverTimestamp(),
          ),
          Award(
            id: '2',
            name: 'Weight Goal Progress',
            points: 50,
            description: 'Reached 50% of your weight goal',
            picture: 'assets/images/award2.png',
            isAwarded: false,
            awarded: null,
          ),
          Award(
            id: '3',
            name: 'Consistency King',
            points: 100,
            description: 'Logged meals for 7 days straight',
            picture: 'assets/images/award3.png',
            isAwarded: false,
            awarded: null,
          ),
        ];

        // Add each default award
        for (final award in defaultAwards) {
          await awardsRef.doc(award.id).set(award.toMap());
        }
      }
    } catch (e) {
      print('Error ensuring awards collection: $e');
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