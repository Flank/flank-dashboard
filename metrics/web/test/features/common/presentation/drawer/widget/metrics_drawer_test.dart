// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/pages/login_page.dart';
import 'package:metrics/features/auth/presentation/state/auth_store.dart';
import 'package:metrics/features/common/presentation/drawer/widget/metrics_drawer.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:metrics/features/common/presentation/routes/route_generator.dart';
import 'package:metrics/features/common/presentation/strings/common_strings.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../../../test_utils/signed_in_auth_store_fake.dart';

void main() {
  testWidgets(
    "Changes theme store state on tap on checkbox",
    (WidgetTester tester) async {
      final themeStore = ThemeStore();

      await tester.pumpWidget(MetricsDrawerTestbed(
        themeStore: themeStore,
      ));

      expect(themeStore.isDark, isFalse);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(themeStore.isDark, isTrue);
    },
  );

  testWidgets(
    "After a user taps on 'Log out' - application navigates back to the login screen",
    (WidgetTester tester) async {
      await tester.pumpWidget(const MetricsDrawerTestbed());

      await tester.tap(find.text(CommonStrings.logOut));
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
    },
  );
}

class MetricsDrawerTestbed extends StatelessWidget {
  final ThemeStore themeStore;

  const MetricsDrawerTestbed({
    Key key,
    this.themeStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject<ThemeStore>(() => themeStore ?? ThemeStore()),
        Inject<AuthStore>(() => SignedInAuthStoreFake()),
      ],
      initState: _initInjectorState,
      builder: (context) {
        return MaterialApp(
          home: Scaffold(
            body: MetricsDrawer(),
          ),
          onGenerateRoute: (settings) => RouteGenerator.generateRoute(
            settings: settings,
            isLoggedIn: Injector.get<AuthStore>().isLoggedIn,
          ),
        );
      },
    );
  }

  void _initInjectorState() {
    Injector.getAsReactive<ThemeStore>()
        .setState((model) => model.isDark = false);
    Injector.getAsReactive<AuthStore>()
        .setState((model) => model.subscribeToAuthenticationUpdates());
  }
}
