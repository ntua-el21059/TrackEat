import '../../../../../../core/app_export.dart';

/// This class is used in the [read_two_item_widget] screen.
/// It represents a single notification item with a message and an ID.
// ignore_for_file: must_be_immutable
class ReadTwoItemModel {
  // Constructor with optional parameters for message and ID
  ReadTwoItemModel({this.timcookse1nt, this.id}) {
    // Default values if parameters are null
    timcookse1nt = timcookse1nt ?? "@tim_cook se1nt a message";
    id = id ?? "";
  }

  // Properties to store the notification message and ID
  String? timcookse1nt;
  String? id;
}
