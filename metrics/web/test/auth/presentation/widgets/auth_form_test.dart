import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/auth/presentation/widgets/password_sign_in_option.dart';
import 'package:metrics/auth/presentation/widgets/sign_in_option_button.dart';
import 'package:metrics/auth/presentation/widgets/strategy/google_sign_in_option_appearance_strategy.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/instant_config/presentation/state/instant_config_notifier.dart';
import 'package:metrics/instant_config/presentation/view_models/login_form_instant_config_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/instant_config_notifier_mock.dart';
import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("AuthForm", () {
    InstantConfigNotifier instantConfigNotifier;

    setUp(() {
      instantConfigNotifier = InstantConfigNotifierMock();
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
      "displays the password sign in option if the password sign in option is enabled in instant config",
      (WidgetTester tester) async {
        when(instantConfigNotifier.loginFormInstantConfigViewModel).thenReturn(
          const LoginFormInstantConfigViewModel(isEnabled: true),
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _AuthFormTestbed(instantConfigNotifier: instantConfigNotifier),
          );
        });

        expect(find.byType(PasswordSignInOption), findsOneWidget);
      },
    );

    testWidgets(
      "does not display the password sign in option if the password sign in option is not enabled in instant config",
      (WidgetTester tester) async {
        when(instantConfigNotifier.loginFormInstantConfigViewModel).thenReturn(
          const LoginFormInstantConfigViewModel(isEnabled: false),
        );

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _AuthFormTestbed(instantConfigNotifier: instantConfigNotifier),
          );
        });

        expect(find.byType(PasswordSignInOption), findsNothing);
      },
    );
  });
}

/// A testbed widget used to test the [AuthForm] widget.
class _AuthFormTestbed extends StatelessWidget {
  /// An [InstantConfigNotifier] used in tests.
  final InstantConfigNotifier instantConfigNotifier;

  /// A [MetricsThemeData] to use in tests.
  final MetricsThemeData metricsThemeData;

  /// Creates the [_AuthFormTestbed] with the given [instantConfigNotifier].
  const _AuthFormTestbed({
    this.metricsThemeData = const MetricsThemeData(),
    this.instantConfigNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      instantConfigNotifier: instantConfigNotifier,
      child: MetricsThemedTestbed(
        metricsThemeData: metricsThemeData,
        body: AuthForm(),
      ),
    );
  }
}
