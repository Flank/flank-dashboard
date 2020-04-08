import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/state/user_store.dart';
import 'package:metrics/features/auth/presentation/strings/login_strings.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:metrics/features/common/presentation/routes/route_generator.dart';
import 'package:metrics/features/common/presentation/strings/common_strings.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:rxdart/rxdart.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../../test_utils/metrics_store_stub.dart';
import '../../../../test_utils/user_store_stub.dart';

void main() {
  final emailInputFinder =
      find.widgetWithText(AuthInputField, LoginStrings.email);
  final passwordInputFinder =
      find.widgetWithText(AuthInputField, LoginStrings.password);
  final submitButtonFinder =
      find.widgetWithText(RaisedButton, LoginStrings.signIn);

  group("LoginPage", () {
    testWidgets("contains project\'s title", (WidgetTester tester) async {
      await tester.pumpWidget(_LoginPageTestbed(userStore: UserStore()));

      expect(find.text(CommonStrings.metrics), findsOneWidget);
    });

    testWidgets("contains authentication form", (WidgetTester tester) async {
      await tester.pumpWidget(_LoginPageTestbed(userStore: UserStore()));

      expect(find.byType(AuthForm), findsOneWidget);
    });

    testWidgets("navigates to the dashboard page if the login was successful",
        (WidgetTester tester) async {
      await tester.pumpWidget(_LoginPageTestbed(userStore: UserStore()));

      await tester.enterText(emailInputFinder, 'test@email.com');
      await tester.enterText(passwordInputFinder, 'testPassword');
      await tester.tap(submitButtonFinder);
      await tester.pumpAndSettle();

      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets(
        "redirects to the dashboard page if a user is already signed in",
        (WidgetTester tester) async {
      await tester.pumpWidget(_LoginPageTestbed(
        userStore: _LoggedInUserStoreStub(),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(DashboardPage), findsOneWidget);
    });
  });
}

class _LoginPageTestbed extends StatelessWidget {
  final UserStore userStore;

  const _LoginPageTestbed({
    this.userStore = const UserStoreStub(),
  });

  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [
        Inject<UserStore>(() => userStore),
        Inject<ProjectMetricsStore>(() => const MetricsStoreStub()),
      ],
      initState: () {
        Injector.getAsReactive<UserStore>().setState(
          (store) => store.subscribeToUserUpdates(),
        );
        Injector.getAsReactive<ProjectMetricsStore>().setState(
          (store) => store.subscribeToProjects(),
          catchError: true,
        );
      },
      builder: (BuildContext context) {
        return MaterialApp(
          title: 'Login Page',
          onGenerateRoute: (settings) =>
              RouteGenerator.generateRoute(settings: settings),
        );
      },
    );
  }
}

class _LoggedInUserStoreStub extends UserStoreStub {
  _LoggedInUserStoreStub();

  final BehaviorSubject<bool> _isLoggedInSubject = BehaviorSubject();

  @override
  Stream get loggedInStream => _isLoggedInSubject.stream;

  @override
  bool get isLoggedIn => _isLoggedInSubject.value;

  @override
  void subscribeToUserUpdates() {
    _isLoggedInSubject.add(true);
  }
}
