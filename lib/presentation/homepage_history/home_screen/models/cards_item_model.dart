import '../../../../core/app_export.dart';

/// This class is used in the [cards_item_widget] screen.
// ignore_for_file: must_be_immutable
class CardsItemModel {
  CardsItemModel({
    this.thumbsupOne,
    this.cutdownsweets,
    this.yourweekly,
    this.id,
  }) {
    thumbsupOne = thumbsupOne ?? ImageConstant.imgThumbsUp;
    cutdownsweets = cutdownsweets ?? "Cut down sweets";
    yourweekly = yourweekly ?? "Your weekly sugar intake is running a bit high!";
    id = id ?? "";
  }

  String? thumbsupOne;
  String? cutdownsweets;
  String? yourweekly;
  String? id;
}
