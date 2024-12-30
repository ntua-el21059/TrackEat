import '../../../core/app_export.dart';
import 'challenges1two_item_model.dart';
import 'listfour_item_model.dart';

// ignore_for_file: must_be_immutable
class Leaderboard12Model {
  // List of players ranked 4-8 with their points
  List<ListfourItemModel> listfourItemList = [
    ListfourItemModel(
        four: "4",
        image: ImageConstant.imgVector32x32,
        garylee: "nancy_reagan",
        ptsCounter: "36 pts"),
    ListfourItemModel(
        four: "5",
        image: ImageConstant.imgVector1,
        garylee: "sophia.richardson",
        ptsCounter: "35 pts"),
    ListfourItemModel(
        four: "6",
        image: ImageConstant.imgVector2,
        garylee: "jappleseed",
        ptsCounter: "34 pts"),
    ListfourItemModel(
        four: "7",
        image: ImageConstant.imgVector3,
        garylee: "emmasullivan",
        ptsCounter: "33 pts"),
    ListfourItemModel(
        four: "8",
        image: ImageConstant.imgVector4,
        garylee: "liam_mitchell",
        ptsCounter: "32 pts")
  ];

  // List of available game challenges
  List<Challenges1twoItemModel> challenges1twoItemList = [
    Challenges1twoItemModel(
        vectorOne: ImageConstant.imgVector76x86,
        avocadoOne: "Avocado \nchallenge"),
    Challenges1twoItemModel(
        vectorOne: ImageConstant.imgVector58x56,
        avocadoOne: "Banana \nchallenge"),
    Challenges1twoItemModel(
        vectorOne: ImageConstant.imgVector62x64,
        avocadoOne: "Carnivore \nchallenge")
  ];
}
