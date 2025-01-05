import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/notifications_model.dart';
import '../notifications_screen.dart';

class NotificationsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<NotificationItem> _notifications = [];
  bool _hasBeenViewed = false;
  NotificationScreenState _screenState = NotificationScreenState.unread;
  bool _isLoading = true;

  bool get hasBeenViewed => _hasBeenViewed;
  bool get isLoading => _isLoading;

  NotificationsProvider() {
    _setupNotificationsListener();
  }

  void _setupNotificationsListener() {
    final currentUser = _auth.currentUser;
    if (currentUser?.email == null) {
      print('Error: No current user or email');
      _isLoading = false;
      notifyListeners();
      return;
    }

    print('Setting up notifications listener for: ${currentUser!.email}');
    
    _firestore
        .collection('users')
        .doc(currentUser.email)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      print('Received notification snapshot with ${snapshot.docs.length} documents');
      
      _notifications = snapshot.docs.map((doc) {
        final data = doc.data();
        print('Processing notification: ${data['message']}');
        return NotificationItem(
          message: data['message'] as String,
          id: doc.id,
          isRead: data['isRead'] as bool,
        );
      }).where((notification) => notification.id != 'notification1').toList();

      _isLoading = false;
      _updateScreenState();
      notifyListeners();
    }, onError: (error) {
      print('Error listening to notifications: $error');
      _isLoading = false;
      notifyListeners();
    });
  }

  NotificationScreenState get screenState {
    if (_hasBeenViewed) {
      if (_notifications.isEmpty) {
        return NotificationScreenState.empty;
      }
      return NotificationScreenState.read;
    }
    return _screenState;
  }

  List<NotificationItem> get unreadNotifications => _notifications
      .where((notification) => !notification.isRead && !_hasBeenViewed)
      .toList();

  List<NotificationItem> get readNotifications => _notifications
      .where((notification) => notification.isRead || _hasBeenViewed)
      .toList();

  bool get hasUnreadNotifications =>
      !_hasBeenViewed && unreadNotifications.isNotEmpty;

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
    _screenState = NotificationScreenState.empty;
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
    _updateScreenState();
    notifyListeners();
  }

  void _updateScreenState() {
    if (_notifications.isEmpty) {
      _screenState = NotificationScreenState.empty;
    } else if (hasUnreadNotifications) {
      _screenState = NotificationScreenState.unread;
    } else {
      _screenState = NotificationScreenState.read;
    }
  }
}
