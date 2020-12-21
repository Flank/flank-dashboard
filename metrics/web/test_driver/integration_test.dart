import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_positive_button.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_form_field.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/widgets/build_number_scorecard.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/coverage_circle_percentage.dart';
import 'package:metrics/dashboard/presentation/widgets/performance_sparkline_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/project_metrics_tile.dart';
import 'package:metrics/dashboard/presentation/widgets/projects_search_input.dart';
import 'package:metrics/main.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_card.dart';
import 'package:universal_io/io.dart';

import 'arguments/model/user_credentials.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("LoginPage", () {
    testWidgets("shows an authentication form", (WidgetTester tester) async {
      await _pumpApp(tester);

      expect(find.byType(AuthForm), findsOneWidget);
    });

    testWidgets("can authenticate in the app using an email and a password",
        (WidgetTester tester) async {
      await _pumpApp(tester);

      await _login(tester);

      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets("can log out from the app", (WidgetTester tester) async {
      await _pumpApp(tester);

      await _openUserMenu(tester);

      await tester.tap(find.text(CommonStrings.logOut));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(AuthForm), findsOneWidget);
    });
  });

  group("DashboardPage", () {
    testWidgets("loads projects and shows the project tiles",
        (WidgetTester tester) async {
      await _pumpApp(tester);

      await _login(tester);

      expect(find.byType(ProjectMetricsTile), findsWidgets);
    });

    testWidgets(
      "loads and displays coverage metric",
      (WidgetTester tester) async {
        await _pumpApp(tester);

        expect(find.byType(CoverageCirclePercentage), findsWidgets);
      },
    );

    testWidgets(
      "loads and displays the performance metric",
      (WidgetTester tester) async {
        await _pumpApp(tester);

        expect(find.byType(PerformanceSparklineGraph), findsWidgets);
      },
    );

    testWidgets(
      "loads and shows the build number metric",
      (WidgetTester tester) async {
        await _pumpApp(tester);

        expect(find.byType(BuildNumberScorecard), findsWidgets);
      },
    );

    testWidgets(
      "loads and shows the build result metrics",
      (WidgetTester tester) async {
        await _pumpApp(tester);

        expect(find.byType(BuildResultBarGraph), findsWidgets);
      },
    );

    testWidgets(
      "project search input filters list of projects",
      (WidgetTester tester) async {
        await _pumpApp(tester);

        final searchInputFinder = find.byType(ProjectSearchInput);
        final noSearchResultsTextFinder =
            find.text(DashboardStrings.noSearchResults);

        await tester.enterText(
          searchInputFinder,
          '_test_filters_project_name_',
        );
        await tester.pumpAndSettle();

        expect(noSearchResultsTextFinder, findsOneWidget);
      },
    );
  });

  group("ProjectGroup page", () {
    testWidgets(
      "shows add project group card button",
      (WidgetTester tester) async {
        await _pumpApp(tester);

        await _openProjectGroupPage(tester);

        expect(find.byType(AddProjectGroupCard), findsOneWidget);
      },
    );
  });
}

Future<void> _login(WidgetTester tester) async {
  final environment = Platform.environment;
  final credentials = UserCredentials.fromMap(environment);

  final emailFinder = find.widgetWithText(
    MetricsTextFormField,
    AuthStrings.email,
  );

  final passwordFinder = find.widgetWithText(
    MetricsTextFormField,
    AuthStrings.password,
  );
  final signInButtonFinder = find.widgetWithText(
    MetricsPositiveButton,
    AuthStrings.signIn,
  );

  await tester.enterText(emailFinder, credentials.email);
  await tester.enterText(passwordFinder, credentials.password);
  await tester.tap(signInButtonFinder);
  await tester.pumpAndSettle();
}

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(MetricsApp());
  await tester.pumpAndSettle();
}

Future<void> _openProjectGroupPage(WidgetTester tester) async {
  await _openUserMenu(tester);

  await tester.tap(find.text(CommonStrings.projectGroups));
  await tester.pumpAndSettle();
}

Future<void> _openUserMenu(WidgetTester tester) async {
  await tester.tap(find.byTooltip(CommonStrings.openUserMenu));
  await tester.pumpAndSettle();
}
