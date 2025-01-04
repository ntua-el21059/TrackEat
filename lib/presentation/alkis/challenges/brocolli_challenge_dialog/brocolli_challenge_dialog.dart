import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../base_challenge_dialog.dart';
import 'provider/brocolli_challenge_provider.dart';

// This directive is used because the widget needs to be mutable to manage its state
// ignore_for_file: must_be_immutable
class BrocolliChallengeDialog extends BaseChallengeDialog {
  // Constructor that accepts an optional key for widget identification
  const BrocolliChallengeDialog({Key? key})
      : super(
          key: key,
        );

  @override
  BrocolliChallengeDialogState createState() => BrocolliChallengeDialogState();

  // A factory method that creates the widget with its state management provider
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BrocolliChallengeProvider(),
      child: BrocolliChallengeDialog(),
    );
  }
}

class BrocolliChallengeDialogState
    extends BaseChallengeDialogState<BrocolliChallengeDialog> {
  @override
  String get title => "Broccoli\nchallenge";

  @override
  String get description =>
      "Enjoy crispy roasted broccoli every day for 7 days\n"
      "—crunch your way to better health! 🥦✨";

  @override
  String get timeLeft => "15 days";

  @override
  String get iconPath => "assets/images/broccoli.png";

  @override
  Color get backgroundColor => Color(0xFF000000); // Green color from the design
}
