import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/widgets/sign_in_option_button.dart';
import 'package:metrics/auth/presentation/widgets/strategy/sign_in_option_strategy.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/login_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/auth_notifier_mock.dart';
import '../../../test_utils/finder_util.dart';
import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/test_injection_container.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("SignInOptionButton", () {
    const label = 'Label';
    const asset = 'icons/icon.svg';
    const splashColor = Colors.pink;
    const highlightColor = Colors.green;
    const metricsThemeData = MetricsThemeData(
      loginTheme: LoginThemeData(
        loginOptionButtonStyle: MetricsButtonStyle(
          color: Colors.green,
          hoverColor: Colors.lightGreen,
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 12.0,
          ),
          elevation: 4.0,
        ),
      ),
    );

    const strategyStub = _SignInOptionStrategyStub(
      asset: asset,
      label: label,
    );

    final themeData = ThemeData(
      splashColor: splashColor,
      highlightColor: highlightColor,
    );

    final buttonFinder = find.ancestor(
      of: find.text(label),
      matching: find.byType(RaisedButton),
    );

    testWidgets(
      "throws an AssertionError if the given strategy is null",
      (tester) async {
        await tester.pumpWidget(const _LoginOptionButtonTestbed(
          strategy: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays an asset from the given strategy",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _LoginOptionButtonTestbed(
            strategy: strategyStub,
          ));
        });

        final image = FinderUtil.findNetworkImageWidget(tester);
        final source = image.url;

        expect(source, equals(asset));
      },
    );

    testWidgets(
      "displays a label from the given strategy",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _LoginOptionButtonTestbed(
            strategy: strategyStub,
          ));
        });

        final finder = find.text(label);

        expect(finder, findsOneWidget);
      },
    );

    testWidgets(
      "applies a label text style from the theme to the option button label",
      (tester) async {
        final expectedStyle =
            metricsThemeData.loginTheme.loginOptionButtonStyle.labelStyle;

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _LoginOptionButtonTestbed(
            metricsThemeData: metricsThemeData,
            strategy: strategyStub,
          ));
        });

        final text = tester.widget<Text>(find.text(label));
        final style = text.style;

        expect(style, equals(expectedStyle));
      },
    );

    testWidgets(
      "applies a color from the theme to the option button",
      (tester) async {
        final expectedColor =
            metricsThemeData.loginTheme.loginOptionButtonStyle.color;

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _LoginOptionButtonTestbed(
            metricsThemeData: metricsThemeData,
            strategy: strategyStub,
          ));
        });

        final button = tester.widget<RaisedButton>(buttonFinder);
        final color = button.color;

        expect(color, equals(expectedColor));
      },
    );

    testWidgets(
      "applies a hover color from the theme to the option button",
      (tester) async {
        final expectedColor =
            metricsThemeData.loginTheme.loginOptionButtonStyle.hoverColor;

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _LoginOptionButtonTestbed(
            metricsThemeData: metricsThemeData,
            strategy: strategyStub,
          ));
        });

        final button = tester.widget<RaisedButton>(buttonFinder);
        final hoverColor = button.hoverColor;

        expect(hoverColor, equals(expectedColor));
      },
    );

    testWidgets(
      "applies an elevation from the theme to the option button",
      (tester) async {
        final expectedElevation =
            metricsThemeData.loginTheme.loginOptionButtonStyle.elevation;

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _LoginOptionButtonTestbed(
            metricsThemeData: metricsThemeData,
            strategy: strategyStub,
          ));
        });

        final button = tester.widget<RaisedButton>(buttonFinder);

        expect(button.elevation, equals(expectedElevation));
        expect(button.hoverElevation, equals(expectedElevation));
        expect(button.focusElevation, equals(expectedElevation));
        expect(button.highlightElevation, equals(expectedElevation));
      },
    );

    testWidgets(
      "calls the sign in method from the given strategy when the option button is pressed",
      (tester) async {
        final authNotifierMock = AuthNotifierMock();
        final strategyMock = _SignInOptionStrategyMock();

        when(strategyMock.asset).thenReturn(asset);
        when(strategyMock.label).thenReturn(label);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_LoginOptionButtonTestbed(
            metricsThemeData: metricsThemeData,
            authNotifier: authNotifierMock,
            strategy: strategyMock,
          ));
        });

        await tester.tap(buttonFinder);

        verify(strategyMock.signIn(authNotifierMock)).called(equals(1));
      },
    );

    testWidgets(
      "applies a splash color to the button from the theme",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_LoginOptionButtonTestbed(
            themeData: themeData,
            strategy: strategyStub,
          ));
        });
        final button = tester.widget<RaisedButton>(buttonFinder);

        expect(button.splashColor, equals(splashColor));
      },
    );

    testWidgets(
      "applies a highlight color to the button from the theme",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_LoginOptionButtonTestbed(
            themeData: themeData,
            strategy: strategyStub,
          ));
        });
        final button = tester.widget<RaisedButton>(buttonFinder);

        expect(button.highlightColor, equals(highlightColor));
      },
    );
  });
}

class _SignInOptionStrategyMock extends Mock implements SignInOptionStrategy {}

/// A stub implementation of the [SignInOptionStrategy] to use in tests.
class _SignInOptionStrategyStub implements SignInOptionStrategy {
  @override
  final String asset;

  @override
  final String label;

  /// Creates a new instance of the sign in option stub.
  ///
  /// The [asset] defaults to the `asset`.
  /// The [label] defaults to the `label`.
  const _SignInOptionStrategyStub({
    this.asset = 'asset',
    this.label = 'label',
  });

  @override
  void signIn(AuthNotifier notifier) {}
}

/// A testbed widget, used to test the [SignInOptionButton] widget.
class _LoginOptionButtonTestbed extends StatelessWidget {
  /// An [AuthNotifier] to use in tests.
  final AuthNotifier authNotifier;

  /// A [ThemeData] used in tests.
  final ThemeData themeData;

  /// A [MetricsThemeData] to use in tests.
  final MetricsThemeData metricsThemeData;

  /// A [SignInOptionStrategy] to apply for the button under tests.
  final SignInOptionStrategy strategy;

  /// Creates a new instance of the [_LoginOptionButtonTestbed].
  ///
  /// The [metricsThemeData] defaults to an empty [MetricsThemeData] instance.
  const _LoginOptionButtonTestbed({
    Key key,
    this.metricsThemeData = const MetricsThemeData(),
    this.themeData,
    this.authNotifier,
    this.strategy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      authNotifier: authNotifier,
      child: MetricsThemedTestbed(
        themeData: themeData,
        metricsThemeData: metricsThemeData,
        body: SignInOptionButton(
          strategy: strategy,
        ),
      ),
    );
  }
}
