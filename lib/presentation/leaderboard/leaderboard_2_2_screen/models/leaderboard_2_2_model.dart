import '../../../core/app_export.dart';
import 'challenges2two_item_model.dart';
import 'listfour_item_model.dart';

// Data model class containing the lists of leaderboard entries and challenge items
class Leaderboard22Model {
  // List of leaderboard entries showing user rankings from 4th to 8th place
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

  // List of available challenges shown in the challenge carousel
  List<Challenges2twoItemModel> challenges2twoItemList = [
    Challenges2twoItemModel(
        vectorOne: ImageConstant.imgVector78x72,
        beatlesOne: "beatles \nchallenge"),
    Challenges2twoItemModel(
        vectorOne: ImageConstant.imgVector60x60,
        beatlesOne: "Brocolli \nchallenge"),
    Challenges2twoItemModel(
        vectorOne: ImageConstant.imgVector60x72, beatlesOne: "Wrap \nchallenge")
  ];
}
