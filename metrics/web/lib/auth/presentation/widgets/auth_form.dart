import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/widgets/password_sign_in_option.dart';
import 'package:metrics/auth/presentation/widgets/sign_in_option_button.dart';
import 'package:metrics/auth/presentation/widgets/strategy/google_sign_in_option_appearance_strategy.dart';
import 'package:metrics/instant_config/presentation/state/instant_config_notifier.dart';
import 'package:provider/provider.dart';

/// Shows an authentication form to sign in.
class AuthForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<InstantConfigNotifier, bool>(
      selector: (_, notifier) {
        return notifier.loginFormInstantConfigViewModel.isEnabled;
      },
      builder: (_, isLoginFormEnabled, __) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLoginFormEnabled) const PasswordSignInOption(),
            SignInOptionButton(
              strategy: GoogleSignInOptionAppearanceStrategy(),
            ),
          ],
        );
      },
    );
  }
}
