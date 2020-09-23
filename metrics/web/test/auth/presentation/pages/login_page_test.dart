import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/pages/login_page.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/common/presentation/metrics_theme/model/login_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/toast/widgets/negative_toast.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import '../../../test_utils/auth_notifier_mock.dart';
import '../../../test_utils/auth_notifier_stub.dart';
import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("LoginPage", () {
    const metricsThemeData = MetricsThemeData(
      loginTheme: LoginThemeData(
        titleTextStyle: TextStyle(
          color: Colors.blue,
          fontSize: 20.0,
        ),
      ),
    );

    testWidgets(
      "displays the welcome message",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _LoginPageTestbed());
        });

        expect(find.text(CommonStrings.welcomeMetrics), findsOneWidget);
      },
    );

    testWidgets(
      "applies the title text style from the theme to the welcome message",
      (WidgetTester tester) async {
        final expectedStyle = metricsThemeData.loginTheme.titleTextStyle;

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _LoginPageTestbed(
            metricsThemeData: metricsThemeData,
          ));
        });

        final text = tester.widget<Text>(
          find.text(CommonStrings.welcomeMetrics),
        );
        final style = text.style;

        expect(style, equals(expectedStyle));
      },
    );

    testWidgets(
      "applies the theme brightness that corresponds the operating system's brightness",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _LoginPageTestbed());
        });

        final context = _LoginPageTestbed.childKey.currentContext;

        final platformBrightness = tester.binding.window.platformBrightness;
        final isDark = platformBrightness == Brightness.dark;

        final themeNotifier =
            Provider.of<ThemeNotifier>(context, listen: false);

        expect(
          themeNotifier.isDark,
          equals(isDark),
        );
      },
    );

    testWidgets(
      "displays the authentication form",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(const _LoginPageTestbed());
        });

        expect(find.byType(AuthForm), findsOneWidget);
      },
    );

    testWidgets(
      "displays the negative toast when there is an auth error message",
      (WidgetTester tester) async {
        const error = "Something went wrong";

        final authNotifier = AuthNotifierMock();
        when(authNotifier.isLoading).thenReturn(false);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_LoginPageTestbed(
            authNotifier: authNotifier,
          ));
        });

        when(authNotifier.authErrorMessage).thenReturn(error);
        authNotifier.notifyListeners();
        await tester.pumpAndSettle();

        expect(find.widgetWithText(NegativeToast, error), findsOneWidget);

        ToastManager().dismissAll();
      },
    );

    testWidgets(
      "navigates to the dashboard page if the login was successful",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_LoginPageTestbed(
            authNotifier: AuthNotifierStub(),
          ));
        });

        await tester.enterText(
          find.widgetWithText(TextFormField, AuthStrings.email),
          'test@email.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, AuthStrings.password),
          'testPassword',
        );
        await tester.tap(find.widgetWithText(RaisedButton, AuthStrings.signIn));

        await mockNetworkImagesFor(() {
          return tester.pumpAndSettle();
        });

        expect(find.byType(DashboardPage), findsOneWidget);
      },
    );
  });
}

/// A testbed widget, used to test the [LoginPage] widget.
class _LoginPageTestbed extends StatelessWidget {
  /// A [GlobalKey] needed to get the current context of the [LoginPage].
  static final GlobalKey childKey = GlobalKey();

  /// A [MetricsThemeData] to use in tests.
  final MetricsThemeData metricsThemeData;

  /// An [AuthNotifier] used in tests.
  final AuthNotifier authNotifier;

  /// A [ProjectMetricsNotifier] used in tests.
  final ProjectMetricsNotifier metricsNotifier;

  /// Creates the [_LoginPageTestbed] with the given [authNotifier] and [metricsNotifier].
  ///
  /// The [metricsThemeData] defaults to an empty [MetricsThemeData] instance.
  const _LoginPageTestbed({
    this.metricsThemeData = const MetricsThemeData(),
    this.authNotifier,
    this.metricsNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      authNotifier: authNotifier,
      metricsNotifier: metricsNotifier,
      child: Builder(
        builder: (context) {
          return MetricsThemedTestbed(
            metricsThemeData: metricsThemeData,
            onGenerateRoute: (settings) => RouteGenerator.generateRoute(
              settings: settings,
              isLoggedIn:
                  Provider.of<AuthNotifier>(context, listen: false).isLoggedIn,
            ),
            body: LoginPage(key: childKey),
          );
        },
      ),
    );
  }
}
