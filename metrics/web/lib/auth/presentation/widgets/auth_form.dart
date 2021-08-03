// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/widgets/password_sign_in_option.dart';
import 'package:metrics/auth/presentation/widgets/sign_in_option_button.dart';
import 'package:metrics/auth/presentation/widgets/strategy/google_sign_in_option_appearance_strategy.dart';
import 'package:metrics/feature_config/presentation/state/feature_config_notifier.dart';
import 'package:provider/provider.dart';

/// Shows an authentication form to sign in.
class AuthForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<FeatureConfigNotifier, bool>(
      selector: (_, notifier) {
        return notifier.passwordSignInOptionFeatureConfigViewModel.isEnabled;
      },
      builder: (_, isPasswordSignInOptionEnabled, __) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const PasswordSignInOption(),
            SignInOptionButton(
              strategy: GoogleSignInOptionAppearanceStrategy(),
            ),
          ],
        );
      },
    );
  }
}
