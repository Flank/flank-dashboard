import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/auth/domain/entities/user.dart';
import 'package:metrics/auth/presentation/pages/loading_page.dart';
import 'package:metrics/auth/presentation/pages/login_page.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../test_utils/test_injection_container.dart';
import '../../test_utils/receive_authentication_updates_mock.dart';
import '../../test_utils/sign_in_usecase_mock.dart';
import '../../test_utils/sign_out_usecase_mock.dart';

void main() {
  final signInUseCase = SignInUseCaseMock();
  final signOutUseCase = SignOutUseCaseMock();
  final receiveAuthUpdates = ReceiveAuthenticationUpdatesMock();

  group("LoadingPage", () {
    testWidgets("displays on the application initial loading",
        (WidgetTester tester) async {
      await tester.pumpWidget(const _LoadingPageTestbed());

      expect(find.byType(LoadingPage), findsOneWidget);
    });

    testWidgets("redirects to the LoginPage if a user is not signed in",
        (WidgetTester tester) async {
      final authNotifier = AuthNotifier(
        receiveAuthUpdates,
        signInUseCase,
        signOutUseCase,
      );

      when(receiveAuthUpdates()).thenAnswer((_) => Stream.value(null));

      await tester.pumpWidget(_LoadingPageTestbed(authNotifier: authNotifier));
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets("redirects to the DashboardPage if a user is signed in",
        (WidgetTester tester) async {
      final authNotifier = AuthNotifier(
        receiveAuthUpdates,
        signInUseCase,
        signOutUseCase,
      );

      final user = User(id: 'id', email: 'test@email.com');

      when(receiveAuthUpdates()).thenAnswer((_) => Stream.value(user));

      await tester.pumpWidget(_LoadingPageTestbed(authNotifier: authNotifier));
      await tester.pumpAndSettle();

      expect(find.byType(DashboardPage), findsOneWidget);
    });
  });
}

/// A testbed widget, used to test the [LoadingPage] widget.
class _LoadingPageTestbed extends StatelessWidget {
  final AuthNotifier authNotifier;

  /// Creates the [_LoadingPageTestbed] with the given [authNotifier].
  const _LoadingPageTestbed({
    this.authNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      authNotifier: authNotifier,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: CommonStrings.metrics,
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
