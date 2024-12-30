import '../../../core/app_export.dart';

/// This class is used in the [listfour_item_widget] screen.
// ignore_for_file: must_be_immutable
class ListfourItemModel {
  ListfourItemModel(
      {this.four, this.image, this.garylee, this.ptsCounter, this.id}) {
    four = four ?? "4";
    image = image ?? ImageConstant.imgVector32x32;
    garylee = garylee ?? "nancy_reagan";
    ptsCounter = ptsCounter ?? "36 pts";
    id = id ?? "";
  }

  String? four;
  String? image;
  String? garylee;
  String? ptsCounter;
  String? id;
}
