import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../base_challenge_dialog.dart';
import 'provider/carnivore_challenge_provider.dart';

// This directive indicates that we intentionally want this widget to be mutable
// ignore_for_file: must_be_immutable
class CarnivoreChallengeDialog extends BaseChallengeDialog {
  // Constructor with an optional key parameter for widget identification
  const CarnivoreChallengeDialog({Key? key})
      : super(
          key: key,
        );

  @override
  CarnivoreChallengeDialogState createState() =>
      CarnivoreChallengeDialogState();

  // Factory method that sets up the widget with its state management provider
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CarnivoreChallengeProvider(),
      child: CarnivoreChallengeDialog(),
    );
  }
}

class CarnivoreChallengeDialogState
    extends BaseChallengeDialogState<CarnivoreChallengeDialog> {
  @override
  String get title => "Carnivore\nchallenge";

  @override
  String get description => "Eat beef once a day for 5 days—fuel your body, embrace the challenge! 🥩🔥";

  @override
  String get timeLeft => "20 days";

  @override
  String get iconPath => "assets/images/meat.png";

  @override
  Color get backgroundColor => Color(0xFFFF3B30); // Green color from the design
}
