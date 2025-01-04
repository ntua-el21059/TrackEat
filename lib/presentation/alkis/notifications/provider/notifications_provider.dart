import 'package:flutter/material.dart';
import '../models/notifications_model.dart';
import '../notifications_screen.dart';

class NotificationsProvider extends ChangeNotifier {
  NotificationsModel _model = NotificationsModel();
  NotificationScreenState _screenState = NotificationScreenState.unread;

  NotificationsProvider() {
    _resetNotifications();
  }

  void _resetNotifications() {
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
        message: "@olie12 started carnivore challenge",
        id: "3",
        isRead: false,
      ),
      NotificationItem(
        message: "@miabrooksier added you",
        id: "4",
        isRead: false,
      ),
      NotificationItem(
        message: "@benreeds sent a message",
        id: "5",
        isRead: false,
      ),
      NotificationItem(
        message: "@emfos93 added you",
        id: "6",
        isRead: false,
      ),
    ];
    _updateScreenState();
    notifyListeners();
  }

  NotificationScreenState get screenState => _screenState;

  List<NotificationItem> get unreadNotifications => _model.notifications
      .where((notification) => !notification.isRead)
      .toList();

  List<NotificationItem> get readNotifications => _model.notifications
      .where((notification) => notification.isRead)
      .toList();

  bool get hasUnreadNotifications => unreadNotifications.isNotEmpty;

  void clearNotifications() {
    _model.notifications.clear();
    _screenState = NotificationScreenState.empty;
    notifyListeners();
  }

  void markAllAsRead() {
    List<NotificationItem> updatedNotifications = [];
    for (var notification in _model.notifications) {
      updatedNotifications.add(
        NotificationItem(
          message: notification.message,
          id: notification.id,
          isRead: true,
        ),
      );
    }
    _model.notifications = updatedNotifications;
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
