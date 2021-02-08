// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/widgets/strategy/sign_in_option_appearance_strategy.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/login_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:test/test.dart';

void main() {
  group("SignInOptionAppearanceStrategy", () {
    const loginThemeData = LoginThemeData(
      loginOptionButtonStyle: MetricsButtonStyle(
        color: Colors.red,
      ),
      inactiveLoginOptionButtonStyle: MetricsButtonStyle(
        color: Colors.grey,
      ),
    );
    const metricsTheme = MetricsThemeData(
      loginTheme: loginThemeData,
    );

    final strategy = _SignInOptionAppearanceStrategyFake();

    test(
      ".getWidgetAppearance() returns the login option button style of the given theme if not in the loading state",
      () {
        final expectedStyle = loginThemeData.loginOptionButtonStyle;

        final actualStyle = strategy.getWidgetAppearance(metricsTheme, false);

        expect(actualStyle, equals(expectedStyle));
      },
    );

    test(
      ".getWidgetAppearance() returns the inactive login option button style of the given theme if in the loading state",
      () {
        final expectedStyle = loginThemeData.inactiveLoginOptionButtonStyle;

        final actualStyle = strategy.getWidgetAppearance(metricsTheme, true);

        expect(actualStyle, equals(expectedStyle));
      },
    );
  });
}

/// A [SignInOptionAppearanceStrategy] fake class needed to test
/// the non-abstract methods.
class _SignInOptionAppearanceStrategyFake
    extends SignInOptionAppearanceStrategy {
  @override
  String get asset => null;

  @override
  String get label => null;

  @override
  void signIn(AuthNotifier notifier) {}
}
