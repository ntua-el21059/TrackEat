class NotificationItem {
  final String message;
  final String id;
  bool isRead;

  NotificationItem({
    required this.message,
    required this.id,
    required this.isRead,
  });
}

class NotificationsModel {
  List<NotificationItem> notifications = [
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
      isRead: true,
    ),
    NotificationItem(
      message: "@benreeds sent a message",
      id: "5",
      isRead: true,
    ),
    NotificationItem(
      message: "@emfos93 added you",
      id: "6",
      isRead: true,
    ),
  ];
}
