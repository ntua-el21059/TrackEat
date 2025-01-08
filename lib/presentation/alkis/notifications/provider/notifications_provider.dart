import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../models/notifications_model.dart';
import '../notifications_screen.dart';

class NotificationsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<NotificationItem> _notifications = [];
  bool _hasBeenViewed = false;
  StreamSubscription<QuerySnapshot>? _notificationsSubscription;

  bool get hasBeenViewed => _hasBeenViewed;

  NotificationsProvider() {
    _setupNotificationsListener();
    // Listen for auth state changes
    _auth.authStateChanges().listen((User? user) {
      _cleanupAndReset();  // Clean up immediately when auth state changes
      if (user != null) {
        print('Auth state changed, setting up notifications for: ${user.email}');
        _setupNotificationsListener();
      } else {
        print('Auth state changed: No user logged in');
      }
    });
  }

  void _cleanupAndReset() {
    print('Cleaning up notifications');
    _notificationsSubscription?.cancel();
    _notifications.clear();  // Use clear() instead of reassignment
    _hasBeenViewed = false;
    notifyListeners();
  }

  void _setupNotificationsListener() {
    // Cancel any existing subscription first
    _notificationsSubscription?.cancel();
    _notifications.clear();  // Use clear() instead of reassignment

    final currentUser = _auth.currentUser;
    if (currentUser?.email == null) {
      print('Error: No current user or email');
      _cleanupAndReset();  // Clean up if no user
      return;
    }

    print('Setting up notifications listener for: ${currentUser!.email}');
    
    _notificationsSubscription = _firestore
        .collection('users')
        .doc(currentUser.email)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      print('Received notification snapshot with ${snapshot.docs.length} documents for ${currentUser.email}');
      
      // Verify the user hasn't changed before processing
      if (_auth.currentUser?.email != currentUser.email) {
        print('User changed, ignoring notifications update');
        return;
      }

      _notifications = snapshot.docs.map((doc) {
        final data = doc.data();
        print('Processing notification for ${currentUser.email}: ${data}');
        return NotificationItem(
          message: data['message'] as String,
          id: doc.id,
          isRead: data['isRead'] as bool,
          senderId: data['senderId'] as String?,
        );
      }).toList();

      print('Total notifications after processing for ${currentUser.email}: ${_notifications.length}');
      notifyListeners();
    }, onError: (error) {
      print('Error listening to notifications: $error');
      notifyListeners();
    });
  }

  NotificationScreenState get screenState {
    if (_notifications.isEmpty) {
      return NotificationScreenState.empty;
    }
    if (unreadNotifications.isNotEmpty) {
      return NotificationScreenState.unread;
    }
    return NotificationScreenState.read;
  }

  List<NotificationItem> get unreadNotifications => _notifications
      .where((notification) => !notification.isRead)
      .toList();

  List<NotificationItem> get readNotifications => _notifications
      .where((notification) => notification.isRead)
      .toList();

  bool get hasUnreadNotifications => unreadNotifications.isNotEmpty;

  Future<void> clearNotifications() async {
    final currentUser = _auth.currentUser;
    if (currentUser?.email == null) return;

    final batch = _firestore.batch();
    final notifications = await _firestore
        .collection('users')
        .doc(currentUser!.email)
        .collection('notifications')
        .get();

    for (var doc in notifications.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
    _hasBeenViewed = true;
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    final currentUser = _auth.currentUser;
    if (currentUser?.email == null) return;

    final batch = _firestore.batch();
    final notifications = await _firestore
        .collection('users')
        .doc(currentUser!.email)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in notifications.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
    _hasBeenViewed = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _cleanupAndReset();
    super.dispose();
  }
}
