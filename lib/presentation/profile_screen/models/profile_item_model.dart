

/// This class is used in the [profile_item_widget] screen.
// ignore_for_file: must_be_immutable
class ProfileItemModel {
  String? title;
  String? value;
  String? icon;

  ProfileItemModel({
    this.title = "Activity Level",
    this.value = "Moderate",
    this.icon = "assets/images/imgTelevision.png",
  });
}