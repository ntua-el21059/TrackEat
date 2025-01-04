import 'package:flutter/material.dart';
import '../models/notifications_model.dart';
import '../notifications_screen.dart';

class NotificationsProvider extends ChangeNotifier {
  NotificationsModel _model = NotificationsModel();
  NotificationScreenState _screenState = NotificationScreenState.unread;
  bool _hasBeenViewed = false;

  bool get hasBeenViewed => _hasBeenViewed;

  NotificationsProvider() {
    _resetNotifications();
  }

  void _resetNotifications() {
    _model = NotificationsModel();
    _hasBeenViewed = false;
    _model.notifications = [
      NotificationItem(
        message: "@nancy_raegan added you",
        id: "1",
        isRead: false,
      ),
      NotificationItem(
        message: "@tim_cook sent a message",
        id: "2",
        isRead: false,
      ),
      NotificationItem(
        message: "@olie12 completed carnivore challenge",
        id: "3",
        isRead: false,
      ),
      NotificationItem(
        message: "@miabrooksier added you",
        id: "4",
        isRead: true,
      ),
      NotificationItem(
        message: "@benreeds sent a message",
        id: "5",
        isRead: true,
      ),
      NotificationItem(
        message: "@emfos93 completed avocado challenge",
        id: "6",
        isRead: true,
      ),
    ];
    _updateScreenState();
    notifyListeners();
  }

  NotificationScreenState get screenState {
    if (_hasBeenViewed) {
      if (_model.notifications.isEmpty) {
        return NotificationScreenState.empty;
      }
      return NotificationScreenState.read;
    }
    return _screenState;
  }

  List<NotificationItem> get unreadNotifications => _model.notifications
      .where((notification) => !notification.isRead && !_hasBeenViewed)
      .toList();

  List<NotificationItem> get readNotifications => _model.notifications
      .where((notification) => notification.isRead || _hasBeenViewed)
      .toList();

  bool get hasUnreadNotifications =>
      !_hasBeenViewed && unreadNotifications.isNotEmpty;

  void clearNotifications() {
    _model.notifications.clear();
    _hasBeenViewed = true;
    _screenState = NotificationScreenState.empty;
    notifyListeners();
  }

  void markAllAsRead() {
    _hasBeenViewed = true;
    for (var notification in _model.notifications) {
      notification.isRead = true;
    }
    _updateScreenState();
    notifyListeners();
  }

  void _updateScreenState() {
    if (_model.notifications.isEmpty) {
      _screenState = NotificationScreenState.empty;
    } else if (hasUnreadNotifications) {
      _screenState = NotificationScreenState.unread;
    } else {
      _screenState = NotificationScreenState.read;
    }
  }
}
