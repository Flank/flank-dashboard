// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/auth/presentation/widgets/password_sign_in_option.dart';
import 'package:metrics/auth/presentation/widgets/sign_in_option_button.dart';
import 'package:metrics/auth/presentation/widgets/strategy/google_sign_in_option_appearance_strategy.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/feature_config/presentation/state/feature_config_notifier.dart';
import 'package:metrics/feature_config/presentation/view_models/password_sign_in_option_feature_config_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/feature_config_notifier_mock.dart';
import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("AuthForm", () {
    FeatureConfigNotifier featureConfigNotifier;

    setUp(() {
      featureConfigNotifier = FeatureConfigNotifierMock();
    });

    testWidgets(
      "displays the google sign in option button with google sign in strategy",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            const _AuthFormTestbed(),
          );
        });

        final googleSignInButton = tester.widget<SignInOptionButton>(
          find.widgetWithText(SignInOptionButton, AuthStrings.signInWithGoogle),
        );

        expect(googleSignInButton, isNotNull);
        expect(googleSignInButton.strategy,
            isA<GoogleSignInOptionAppearanceStrategy>());
      },
    );

    testWidgets(
      "displays the password sign in option if the password sign in option is enabled in feature config",
      (WidgetTester tester) async {
        when(featureConfigNotifier.passwordSignInOptionFeatureConfigViewModel)
            .thenReturn(
          const PasswordSignInOptionFeatureConfigViewModel(isEnabled: true),
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _AuthFormTestbed(featureConfigNotifier: featureConfigNotifier),
          );
        });

        expect(find.byType(PasswordSignInOption), findsOneWidget);
      },
    );

    testWidgets(
      "does not display the password sign in option if the password sign in option is not enabled in feature config",
      (WidgetTester tester) async {
        when(featureConfigNotifier.passwordSignInOptionFeatureConfigViewModel)
            .thenReturn(
          const PasswordSignInOptionFeatureConfigViewModel(isEnabled: false),
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _AuthFormTestbed(featureConfigNotifier: featureConfigNotifier),
          );
        });

        expect(find.byType(PasswordSignInOption), findsNothing);
      },
    );
  });
}

/// A testbed widget used to test the [AuthForm] widget.
class _AuthFormTestbed extends StatelessWidget {
  /// An [FeatureConfigNotifier] used in tests.
  final FeatureConfigNotifier featureConfigNotifier;

  /// A [MetricsThemeData] to use in tests.
  final MetricsThemeData metricsThemeData;

  /// Creates the [_AuthFormTestbed] with the given [featureConfigNotifier].
  const _AuthFormTestbed({
    this.metricsThemeData = const MetricsThemeData(),
    this.featureConfigNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      featureConfigNotifier: featureConfigNotifier,
      child: MetricsThemedTestbed(
        metricsThemeData: metricsThemeData,
        body: AuthForm(),
      ),
    );
  }
}
