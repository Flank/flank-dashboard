import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/state/user_store.dart';
import 'package:metrics/features/auth/presentation/strings/login_strings.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:metrics/features/common/presentation/routes/route_generator.dart';
import 'package:metrics/features/common/presentation/strings/common_strings.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../dashboard/presentation/page/dashboard_page_test.dart';
import '../widgets/auth_form_test.dart';

void main() {
  final Finder emailInput =
      find.widgetWithText(AuthInputField, LoginStrings.email);
  final Finder passwordInput =
      find.widgetWithText(AuthInputField, LoginStrings.password);
  final Finder submitButton =
      find.widgetWithText(RaisedButton, LoginStrings.signIn);

  group('LoginPage', () {
    testWidgets('contains project\'s title', (WidgetTester tester) async {
      await tester.pumpWidget(LoginPageTestbed(userStore: UserStore()));

      expect(find.text(CommonStrings.metrics), findsOneWidget);
    });

    testWidgets('contains authentication form', (WidgetTester tester) async {
      await tester.pumpWidget(LoginPageTestbed(userStore: UserStore()));

      expect(emailInput, findsOneWidget);
      expect(passwordInput, findsOneWidget);
      expect(submitButton, findsOneWidget);
    });

    testWidgets('navigates to the dashboard page if the login was successful',
        (WidgetTester tester) async {
      await tester.pumpWidget(LoginPageTestbed(userStore: UserStore()));

      await tester.enterText(emailInput, 'test@email.com');
      await tester.enterText(passwordInput, 'testPassword');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets(
        'redirects to the dashboard page if a user is already signed in',
        (WidgetTester tester) async {
      await tester.pumpWidget(LoginPageTestbed(
        userStore: UserIsLoggedInUserStoreStub(),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(DashboardPage), findsOneWidget);
    });
  });
}

class LoginPageTestbed extends StatelessWidget {
  final UserStore userStore;

  const LoginPageTestbed({
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
        final ReactiveModel<UserStore> userStoreRM =
            Injector.getAsReactive<UserStore>();
        return MaterialApp(
          title: 'Login Page',
          onGenerateRoute: (settings) => RouteGenerator.generateRoute(
            settings: settings,
            isLoggedIn: userStoreRM.state.isLoggedIn,
          ),
        );
      },
    );
  }
}
