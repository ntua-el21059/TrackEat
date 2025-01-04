import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../base_challenge_dialog.dart';
import 'provider/banana_challenge_provider.dart';

// This directive indicates that we intentionally want this widget to be mutable
// ignore_for_file: must_be_immutable
class BananaChallengeDialog extends BaseChallengeDialog {
  // Constructor with an optional key parameter
  const BananaChallengeDialog({Key? key})
      : super(
          key: key,
        );

  @override
  BananaChallengeDialogState createState() => BananaChallengeDialogState();

  // Factory method to create the widget with its associated provider
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BananaChallengeProvider(),
      child: BananaChallengeDialog(),
    );
  }
}

class BananaChallengeDialogState
    extends BaseChallengeDialogState<BananaChallengeDialog> {
  @override
  String get title => "Banana\nchallenge";

  @override
  String get description => "Bake and enjoy a slice of homemade banana \n"
      "bread every day for a week—comfort and \n"
      "flavor in every bite! 🍌🍞✨";

  @override
  String get timeLeft => "10 days";

  @override
  String get iconPath => "assets/images/banana.png";

  @override
  Color get backgroundColor => Color(0xFFFFCC00); // Green color from the design
}
