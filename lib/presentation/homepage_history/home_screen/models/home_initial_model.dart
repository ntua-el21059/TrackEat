import '../../../../core/app_export.dart';
import 'cards_item_model.dart';

/// This class is used in the [home_initial_page] screen.
// ignore_for_file: must_be_immutable
class HomeInitialModel {
  List<CardsItemModel> cardsItemList = [
    CardsItemModel(
      thumbsupOne: ImageConstant.imgThumbsUp,
      cutdownsweets: "Cut down sweets",
      yourweekly: "Your weekly sugar intake is running a bit high!",
    ),
    CardsItemModel(
      thumbsupOne: ImageConstant.imgTicket,
      cutdownsweets: "Boost your greens",
      yourweekly: "A handful can give you extra energy",
    ),
    CardsItemModel(
      thumbsupOne: ImageConstant.imgIcon,
      cutdownsweets: "Sip smarter",
      yourweekly: "Swap sugary drinks for water or tea",
    ),
  ];
}
