import '../../../../core/app_export.dart';

/// This class is used in the [blur_edit_item_widget] screen.
// ignore_for_file: must_be_immutable
class BlurEditItemModel {
  BlurEditItemModel({this.weight, this.protein, this.id}) {
    weight = weight ?? "69g";
    protein = protein ?? "Protein";
    id = id ?? "";
  }

  String? weight;
  String? protein;
  String? id;
}
