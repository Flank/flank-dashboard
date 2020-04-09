import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/pages/login_page.dart';
import 'package:metrics/features/auth/presentation/state/user_store.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/features/common/presentation/drawer/widget/metrics_drawer.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:metrics/features/common/presentation/routes/route_generator.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../../auth/test_utils/sign_in_user_store_stub.dart';

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
      "User is logged out on tap on logout list tile", (WidgetTester tester) async {
      await tester.pumpWidget(MetricsDrawerTestbed());

      await tester.tap(find.byKey(const Key('Logout')));
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
  });
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
        Inject<UserStore>(() => SignInUserStoreStub()),
      ],
      initState: _initInjectorState,
      builder: (context) {
        return MaterialApp(
          home: const Scaffold(
            body: MetricsDrawer(),
          ),
          onGenerateRoute: (settings) =>
              RouteGenerator.generateRoute(settings: settings),
        );
      },
    );
  }

  void _initInjectorState() {
    Injector.getAsReactive<ThemeStore>()
        .setState((model) => model.isDark = false);
    Injector.getAsReactive<UserStore>()
        .setState((model) => model.subscribeToAuthenticationUpdates());
  }
}
