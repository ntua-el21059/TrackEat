import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../base_challenge_dialog.dart';
import 'provider/avocado_challenge_provider.dart';

class AvocadoChallengeDialog extends BaseChallengeDialog {
  const AvocadoChallengeDialog({Key? key}) : super(key: key);

  @override
  AvocadoChallengeDialogState createState() => AvocadoChallengeDialogState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AvocadoChallengeProvider(),
      child: AvocadoChallengeDialog(),
    );
  }
}

class AvocadoChallengeDialogState
    extends BaseChallengeDialogState<AvocadoChallengeDialog> {
  @override
  String get title => "Avocado\nchallenge";

  @override
  String get description =>
      "Savor a slice of avocado toast every morning for 5 days! 🥑🍞✨";

  @override
  String get timeLeft => "29 days";

  @override
  String get iconPath => "assets/images/avocado.png";

  @override
  Color get backgroundColor => Color(0xFF4CD964); // Green color from the design
}
