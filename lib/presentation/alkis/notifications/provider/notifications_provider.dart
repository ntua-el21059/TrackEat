import 'package:flutter/material.dart';
import '../models/notifications_model.dart';
import '../notifications_screen.dart';

class NotificationsProvider extends ChangeNotifier {
  final NotificationsModel _model = NotificationsModel();
  NotificationScreenState _screenState = NotificationScreenState.unread;

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
    for (var notification in _model.notifications) {
      if (!notification.isRead) {
        _model.notifications[_model.notifications.indexOf(notification)] =
            NotificationItem(
          message: notification.message,
          id: notification.id,
          isRead: true,
        );
      }
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
