import '../../../../../../core/app_export.dart';
import 'read_two_item_model.dart';

// This class represents the model for unread notifications
// The must_be_immutable annotation indicates that the class's fields can be modified after initialization
// ignore_for_file: must_be_immutable
class NotificationsUnreadModel {
  // List of unread notification items, each represented by a ReadTwoItemModel
  List<ReadTwoItemModel> readTwoItemList = [
    ReadTwoItemModel(miabrooksier: "@miabrooksier added you"),
    ReadTwoItemModel(miabrooksier: "@benreeds sent a message"),
    ReadTwoItemModel(miabrooksier: "@emfos93 added you"),
    ReadTwoItemModel(miabrooksier: "@gracieharps added you"),
    ReadTwoItemModel(miabrooksier: "@willhayes87 added you"),
    ReadTwoItemModel(miabrooksier: "@tim_cook sent a message")
  ];
}
