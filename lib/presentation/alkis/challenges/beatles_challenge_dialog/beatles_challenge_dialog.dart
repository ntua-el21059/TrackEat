import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../base_challenge_dialog.dart';
import 'provider/beatles_challenge_provider.dart';

class BeatlesChallengeDialog extends BaseChallengeDialog {
  const BeatlesChallengeDialog({Key? key}) : super(key: key);

  @override
  BeatlesChallengeDialogState createState() => BeatlesChallengeDialogState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BeatlesChallengeProvider(),
      child: BeatlesChallengeDialog(),
    );
  }
}

class BeatlesChallengeDialogState
    extends BaseChallengeDialogState<BeatlesChallengeDialog> {
  @override
  String get title => "Beatles\nchallenge";

  @override
  String get description =>
      "Try a beetle salad—crunchy, unique, and packed with nutrients! 🥗✨";

  @override
  String get timeLeft => "12:00:00";

  @override
  String get iconPath => "assets/images/beatles.png";

  @override
  Color get backgroundColor => Color(0xFF007AFF); // Blue color from the design
}
