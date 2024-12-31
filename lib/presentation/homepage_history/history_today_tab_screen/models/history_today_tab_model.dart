// ignore_for_file: must_be_immutable
class HistoryTodayTabModel {
  List<MacroNutrient> macroNutrients = [
    MacroNutrient(amount: "69g", type: "Protein"),
    MacroNutrient(amount: "69g", type: "Fats"),
    MacroNutrient(amount: "69g", type: "Carbs")
  ];
}

class MacroNutrient {
  MacroNutrient({
    required this.amount,
    required this.type,
    this.id,
  });

  String amount;
  String type;
  String? id;
}
