import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/presentation/pages/login_page.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/user_menu_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_user_menu_card.dart';
import 'package:metrics/project_groups/presentation/pages/project_group_page.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import '../../../test_utils/auth_notifier_mock.dart';
import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/signed_in_auth_notifier_stub.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group('MetricsUserMenuCard', () {
    const testBackgroundColor = Colors.white;
    const testDividerColor = Colors.black;
    const testTextStyle = TextStyle(color: Colors.grey);

    const testTheme = MetricsThemeData(
      userMenuTheme: UserMenuThemeData(
        backgroundColor: testBackgroundColor,
        dividerColor: testDividerColor,
        contentTextStyle: testTextStyle,
      ),
    );

    testWidgets(
      "applies the background color from the user menu theme to the card",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsUserMenuCardTestbed(
          theme: testTheme,
        ));

        final cardWidget = tester.widget<Card>(find.byType(Card));

        expect(cardWidget.color, equals(testBackgroundColor));
      },
    );

    testWidgets(
      "applies the divider color from the user menu theme to the divider",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsUserMenuCardTestbed(
          theme: testTheme,
        ));

        final divider = tester.widget<Divider>(find.byType(Divider));

        expect(divider.color, equals(testDividerColor));
      },
    );

    testWidgets(
      "applies the textStyle from the user menu theme to the switch theme text widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsUserMenuCardTestbed(
          theme: testTheme,
        ));

        final textWidget = tester.widget<Text>(
          find.text(CommonStrings.lightTheme),
        );

        expect(textWidget.style, equals(testTextStyle));
      },
    );

    testWidgets(
      "applies the textStyle from the user menu theme to the project groups Text widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsUserMenuCardTestbed(
          theme: testTheme,
        ));

        final textWidget = tester.widget<Text>(
          find.text(CommonStrings.projectGroups),
        );

        expect(textWidget.style, equals(testTextStyle));
      },
    );

    testWidgets(
      "applies the textStyle from the user menu theme to the users Text widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsUserMenuCardTestbed(
          theme: testTheme,
        ));

        final textWidget = tester.widget<Text>(
          find.text(CommonStrings.users),
        );

        expect(textWidget.style, equals(testTextStyle));
      },
    );

    testWidgets(
      "applies the textStyle from the user menu theme to the logOut Text widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsUserMenuCardTestbed(
          theme: testTheme,
        ));

        final textWidget = tester.widget<Text>(
          find.text(CommonStrings.logOut),
        );

        expect(textWidget.style, equals(testTextStyle));
      },
    );

    testWidgets(
      "applies a hand cursor to the project group text widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsUserMenuCardTestbed(
          theme: testTheme,
        ));

        final finder = find.ancestor(
          of: find.text(CommonStrings.projectGroups),
          matching: find.byType(HandCursor),
        );

        expect(finder, findsOneWidget);
      },
    );

    testWidgets(
      "applies a hand cursor to the logOut text widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsUserMenuCardTestbed(
          theme: testTheme,
        ));

        final finder = find.ancestor(
          of: find.text(CommonStrings.logOut),
          matching: find.byType(HandCursor),
        );

        expect(finder, findsOneWidget);
      },
    );

    testWidgets(
      "applies a hand cursor to the flutter switch widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _MetricsUserMenuCardTestbed(
          theme: testTheme,
        ));

        final finder = find.ancestor(
          of: find.byType(FlutterSwitch),
          matching: find.byType(HandCursor),
        );

        expect(finder, findsOneWidget);
      },
    );

    testWidgets(
      "calls the ThemeNotifier.changeTheme() if the switch widget is tapped",
      (WidgetTester tester) async {
        final themeNotifier = ThemeNotifierMock();

        when(themeNotifier.isDark).thenReturn(false);

        await tester.pumpWidget(_MetricsUserMenuCardTestbed(
          theme: testTheme,
          themeNotifier: themeNotifier,
        ));

        await tester.tap(find.byType(FlutterSwitch));
        await tester.pumpAndSettle();

        verify(themeNotifier.changeTheme()).called(equals(1));
      },
    );

    testWidgets(
      "calls the AuthNotifier.signOut() on tap on 'Log out'",
      (tester) async {
        final authNotifier = AuthNotifierMock();

        when(authNotifier.isLoggedIn).thenReturn(true);

        await tester.pumpWidget(_MetricsUserMenuCardTestbed(
          authNotifier: authNotifier,
        ));

        await tester.tap(find.text(CommonStrings.logOut));
        await mockNetworkImagesFor(() {
          return tester.pumpAndSettle();
        });

        verify(authNotifier.signOut()).called(equals(1));
      },
    );

    testWidgets(
      "after a user taps on 'Log out' - application navigates back to the login screen",
      (WidgetTester tester) async {
        await tester.pumpWidget(_MetricsUserMenuCardTestbed(
          authNotifier: SignedInAuthNotifierStub(),
        ));

        await tester.tap(find.text(CommonStrings.logOut));
        await mockNetworkImagesFor(() {
          return tester.pumpAndSettle();
        });

        expect(find.byType(LoginPage), findsOneWidget);
      },
    );

    testWidgets(
      "after a user taps on 'Project groups' - application navigates to the project group screen",
      (WidgetTester tester) async {
        final authNotifier = AuthNotifierMock();

        when(authNotifier.isLoggedIn).thenReturn(true);

        await tester.pumpWidget(_MetricsUserMenuCardTestbed(
          authNotifier: authNotifier,
        ));

        await tester.tap(find.text(CommonStrings.projectGroups));
        await mockNetworkImagesFor(() {
          return tester.pump();
        });

        expect(find.byType(ProjectGroupPage), findsOneWidget);
      },
    );
  });
}

/// A testbed widget, used to test the [MetricsUserMenuCard] widget.
class _MetricsUserMenuCardTestbed extends StatelessWidget {
  /// The [MetricsThemeData] used in testbed.
  final MetricsThemeData theme;

  /// A [ThemeNotifier] used in tests.
  final ThemeNotifier themeNotifier;

  /// An [AuthNotifier] used in tests.
  final AuthNotifier authNotifier;

  /// Creates the [_MetricsUserMenuCardTestbed] with the given [theme].
  const _MetricsUserMenuCardTestbed({
    Key key,
    this.theme = const MetricsThemeData(),
    this.themeNotifier,
    this.authNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      themeNotifier: themeNotifier,
      authNotifier: authNotifier,
      child: Builder(
        builder: (context) {
          return MetricsThemedTestbed(
            metricsThemeData: theme,
            body: const MetricsUserMenuCard(),
            onGenerateRoute: (settings) => RouteGenerator.generateRoute(
              settings: settings,
              isLoggedIn:
                  Provider.of<AuthNotifier>(context, listen: false).isLoggedIn,
            ),
          );
        },
      ),
    );
  }
}

class ThemeNotifierMock extends Mock
    with ChangeNotifier
    implements ThemeNotifier {}
