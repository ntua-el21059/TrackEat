import '../../../core/app_export.dart';
import 'gridvector_one_item_model.dart';
import 'listvegan_item_model.dart';

// ignore_for_file: must_be_immutable
class SocialProfileMyselfModel {
  List<ListveganItemModel> listveganItemList = [
    ListveganItemModel(title: "Carnivore🥩", count: ""),
    ListveganItemModel(
      title: "Tim's been thriving \nwith us for a year!",
      count: "⭐️",
    ),
  ];

  List<GridvectorOneItemModel> gridvectorOneItemList = [
    GridvectorOneItemModel(image: ImageConstant.imgAward1),
    GridvectorOneItemModel(image: ImageConstant.imgAward2),
    GridvectorOneItemModel(image: ImageConstant.imgAward3),
    GridvectorOneItemModel(image: ImageConstant.imgAward4),
    GridvectorOneItemModel(image: ImageConstant.imgAward5),
    GridvectorOneItemModel(image: ImageConstant.imgAward6),
  ];
}