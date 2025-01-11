import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/award_model.dart';

class SocialAwardsProvider extends ChangeNotifier {
  final Map<String, List<Award>> _cachedAwards = {};
  final Map<String, Stream<QuerySnapshot>> _awardStreams = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Award>? getAwards(String email) => _cachedAwards[email];

  Future<void> prefetchAwards(String email) async {
    if (!_cachedAwards.containsKey(email)) {
      try {
        final snapshot = await _firestore
            .collection('users')
            .doc(email)
            .collection('awards')
            .get();

        final awards = snapshot.docs.map((doc) {
          final data = doc.data();
          return Award(
            id: doc.id,
            name: data['name'] ?? '',
            points: data['points'] ?? 0,
            description: data['description'] ?? '',
            picture: data['picture'] ?? '',
            isAwarded: data['isAwarded'] ?? false,
            awarded: data['awarded'],
          );
        }).toList();

        _cachedAwards[email] = awards;
        notifyListeners();
      } catch (e) {
        print('Error prefetching awards: $e');
      }
    }
  }

  Stream<List<Award>> watchAwards(String email) {
    // Start prefetch immediately
    prefetchAwards(email);

    if (!_awardStreams.containsKey(email)) {
      final stream = _firestore
          .collection('users')
          .doc(email)
          .collection('awards')
          .snapshots();
      _awardStreams[email] = stream;

      // Listen to changes and update cache
      stream.listen((snapshot) {
        final awards = snapshot.docs.map((doc) {
          final data = doc.data();
          return Award(
            id: doc.id,
            name: data['name'] ?? '',
            points: data['points'] ?? 0,
            description: data['description'] ?? '',
            picture: data['picture'] ?? '',
            isAwarded: data['isAwarded'] ?? false,
            awarded: data['awarded'],
          );
        }).toList();

        _cachedAwards[email] = awards;
        notifyListeners();
      });
    }

    return _awardStreams[email]!.map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Award(
          id: doc.id,
          name: data['name'] ?? '',
          points: data['points'] ?? 0,
          description: data['description'] ?? '',
          picture: data['picture'] ?? '',
          isAwarded: data['isAwarded'] ?? false,
          awarded: data['awarded'],
        );
      }).toList();
    });
  }

  void dispose() {
    _cachedAwards.clear();
    _awardStreams.clear();
    super.dispose();
  }
} 