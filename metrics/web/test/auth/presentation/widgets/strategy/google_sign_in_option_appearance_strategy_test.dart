import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/widgets/strategy/google_sign_in_option_appearance_strategy.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/login_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/auth_notifier_mock.dart';

void main() {
  group("GoogleSignInOptionAppearanceStrategy", () {
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

    final strategy = GoogleSignInOptionAppearanceStrategy();

    test(".asset equals to the google logo asset", () {
      const expectedAsset = 'icons/logo-google.svg';

      final actualAsset = strategy.asset;

      expect(actualAsset, equals(expectedAsset));
    });

    test(".label equals to the sign in with google message", () {
      const expectedLabel = AuthStrings.signInWithGoogle;

      final actualLabel = strategy.label;

      expect(actualLabel, equals(expectedLabel));
    });

    test(".signIn() delegates sign in to the given notifier", () {
      final notifier = AuthNotifierMock();

      strategy.signIn(notifier);

      verify(notifier.signInWithGoogle()).called(1);
    });

    test(
      ".getWidgetAppearance() returns the login option button theme if not in the loading state",
      () {
        final actualTheme = strategy.getWidgetAppearance(metricsTheme, false);

        expect(actualTheme, loginThemeData.loginOptionButtonStyle);
      },
    );

    test(
      ".getWidgetAppearance() returns the inactive login option button theme if in the loading state",
      () {
        final actualTheme = strategy.getWidgetAppearance(metricsTheme, true);

        expect(actualTheme, loginThemeData.inactiveLoginOptionButtonStyle);
      },
    );
  });
}
