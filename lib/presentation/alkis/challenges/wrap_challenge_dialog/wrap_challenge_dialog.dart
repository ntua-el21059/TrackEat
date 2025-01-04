import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../base_challenge_dialog.dart';
import 'provider/wrap_challenge_provider.dart';

// This directive indicates that the widget is intentionally mutable to manage state
// ignore_for_file: must_be_immutable
class WrapChallengeDialog extends BaseChallengeDialog {
  // Constructor accepting an optional key for widget identification
  const WrapChallengeDialog({Key? key})
      : super(
          key: key,
        );

  @override
  WrapChallengeDialogState createState() => WrapChallengeDialogState();

  // Factory method that creates the widget with its state management provider
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WrapChallengeProvider(),
      child: WrapChallengeDialog(),
    );
  }
}

class WrapChallengeDialogState
    extends BaseChallengeDialogState<WrapChallengeDialog> {
  @override
  String get title => "Wrap\nchallenge";

  @override
  String get description =>
      "Enjoy a healthy burrito—full of\n flavor and goodness! 🌯✨";

  @override
  String get timeLeft => "1 day";

  @override
  String get iconPath => "assets/images/wrap.png";

  @override
  Color get backgroundColor => Color(0xFF9747FF); // Green color from the design
}
