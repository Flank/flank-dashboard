// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/base/presentation/widgets/icon_label_button.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_negative_button.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_positive_button.dart';
import 'package:metrics/common/presentation/metrics_app/metrics_app.dart';
import 'package:metrics/common/presentation/project_search_input/widgets/projects_search_input.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_checkbox.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_form_field.dart';
import 'package:metrics/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/dashboard/presentation/widgets/build_number_scorecard.dart';
import 'package:metrics/dashboard/presentation/widgets/build_result_bar_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/coverage_circle_percentage.dart';
import 'package:metrics/dashboard/presentation/widgets/performance_sparkline_graph.dart';
import 'package:metrics/dashboard/presentation/widgets/project_build_status.dart';
import 'package:metrics/dashboard/presentation/widgets/project_metrics_tile.dart';
import 'package:metrics/dashboard/presentation/widgets/stability_circle_percentage.dart';
import 'package:metrics/platform/stub/metrics_config/metrics_config_factory.dart'
    if (dart.library.html) 'package:metrics/platform/web/metrics_config/metrics_config_factory.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_card.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card.dart';
import 'package:universal_html/html.dart';
import 'package:uuid/uuid.dart';

import 'arguments/model/user_credentials.dart';
import 'test_utils/hover_widget.dart';
import 'test_utils/pump_and_settle_widget.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final configFactory = MetricsConfigFactory();
  final metricsConfig = configFactory.create();

  Future<void> login(WidgetTester tester) async {
    final credentials = UserCredentials.fromEnvironment();

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

  Future<void> openProjectGroupsPage(WidgetTester tester) async {
    await tester.tap(find.byTooltip(CommonStrings.openUserMenu));
    await tester.pumpAndSettle();

    await tester.tap(find.text(CommonStrings.projectGroups));
    await tester.pumpAndSettle();
  }

  group("LoadingPage", () {
    testWidgets(
      "is replaced once the loading finished",
      (tester) async {
        await tester.pumpWidget(MetricsApp(
          metricsConfig: metricsConfig,
        ));

        final expectedPagesLength = window.history.length;

        await tester.pumpAndSettle();

        final actualPagesLength = window.history.length;

        expect(find.byType(AuthForm), findsOneWidget);
        expect(actualPagesLength, equals(expectedPagesLength));
      },
    );
  });

  group("LoginPage", () {
    testWidgets(
      "shows an authentication form",
      (WidgetTester tester) async {
        await tester.pumpAndSettleWidget(MetricsApp(
          metricsConfig: metricsConfig,
        ));

        expect(find.byType(AuthForm), findsOneWidget);
      },
    );

    testWidgets(
      "can authenticate in the app using an email and a password",
      (WidgetTester tester) async {
        await tester.pumpAndSettleWidget(MetricsApp(
          metricsConfig: metricsConfig,
        ));

        await login(tester);

        expect(find.byType(DashboardPage), findsOneWidget);
      },
    );

    testWidgets(
      "can log out from the app",
      (WidgetTester tester) async {
        await tester.pumpAndSettleWidget(MetricsApp(
          metricsConfig: metricsConfig,
        ));

        await tester.tap(find.byTooltip(CommonStrings.openUserMenu));
        await tester.pumpAndSettle();

        await tester.tap(find.text(CommonStrings.logOut));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(find.byType(AuthForm), findsOneWidget);
      },
    );

    testWidgets(
      "is replaced after user logs in",
      (tester) async {
        await tester.pumpAndSettleWidget(MetricsApp(
          metricsConfig: metricsConfig,
        ));

        final expectedPagesLength = window.history.length;

        await login(tester);

        final actualPagesLength = window.history.length;

        expect(find.byType(DashboardPage), findsOneWidget);
        expect(actualPagesLength, equals(expectedPagesLength));
      },
    );
  });

  group("DashboardPage", () {
    testWidgets(
      "loads projects and shows the project tiles",
      (WidgetTester tester) async {
        await tester.pumpAndSettleWidget(MetricsApp(
          metricsConfig: metricsConfig,
        ));

        expect(find.byType(ProjectMetricsTile), findsWidgets);
      },
    );

    testWidgets(
      "loads and displays stability metric",
      (WidgetTester tester) async {
        await tester.pumpAndSettleWidget(MetricsApp(
          metricsConfig: metricsConfig,
        ));

        expect(find.byType(StabilityCirclePercentage), findsWidgets);
      },
    );

    testWidgets(
      "loads and displays project build status metric",
      (WidgetTester tester) async {
        await tester.pumpAndSettleWidget(MetricsApp(
          metricsConfig: metricsConfig,
        ));

        expect(find.byType(ProjectBuildStatus), findsWidgets);
      },
    );

    testWidgets(
      "loads and displays coverage metric",
      (WidgetTester tester) async {
        await tester.pumpAndSettleWidget(MetricsApp(
          metricsConfig: metricsConfig,
        ));

        expect(find.byType(CoverageCirclePercentage), findsWidgets);
      },
    );

    testWidgets(
      "loads and displays the performance metric",
      (WidgetTester tester) async {
        await tester.pumpAndSettleWidget(MetricsApp(
          metricsConfig: metricsConfig,
        ));

        expect(find.byType(PerformanceSparklineGraph), findsWidgets);
      },
    );

    testWidgets(
      "loads and shows the build number metric",
      (WidgetTester tester) async {
        await tester.pumpAndSettleWidget(MetricsApp(
          metricsConfig: metricsConfig,
        ));

        expect(find.byType(BuildNumberScorecard), findsWidgets);
      },
    );

    testWidgets(
      "loads and shows the build result metrics",
      (WidgetTester tester) async {
        await tester.pumpAndSettleWidget(MetricsApp(
          metricsConfig: metricsConfig,
        ));

        expect(find.byType(BuildResultBarGraph), findsWidgets);
      },
    );

    testWidgets(
      "project search input filters list of projects",
      (WidgetTester tester) async {
        await tester.pumpAndSettleWidget(MetricsApp(
          metricsConfig: metricsConfig,
        ));

        final searchInputFinder = find.byType(ProjectSearchInput);
        final noSearchResultsTextFinder = find.text(
          DashboardStrings.noSearchResults,
        );

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
    final uuid = Uuid();
    final projectGroupName = uuid.v1();
    final updatedProjectGroupName = uuid.v1();

    testWidgets(
      "shows add project group card button",
      (WidgetTester tester) async {
        await tester.pumpAndSettleWidget(MetricsApp(
          metricsConfig: metricsConfig,
        ));

        await openProjectGroupsPage(tester);

        expect(find.byType(AddProjectGroupCard), findsOneWidget);
      },
    );

    testWidgets(
      "allows creating a project group",
      (WidgetTester tester) async {
        await tester.pumpAndSettleWidget(MetricsApp(
          metricsConfig: metricsConfig,
        ));
        await openProjectGroupsPage(tester);

        await tester.tap(find.byType(AddProjectGroupCard));
        await tester.pumpAndSettle();

        final projectGroupNameInputFinder = find.widgetWithText(
          MetricsTextFormField,
          ProjectGroupsStrings.nameYourGroup,
        );
        await tester.enterText(projectGroupNameInputFinder, projectGroupName);

        await tester.tap(find.byType(MetricsCheckbox).first);
        await tester.pumpAndSettle();

        final createButtonFinder = find.widgetWithText(
          MetricsPositiveButton,
          ProjectGroupsStrings.createGroup,
        );
        await tester.tap(createButtonFinder);
        await tester.pumpAndSettle();

        final projectGroupCardFinder = find.widgetWithText(
          ProjectGroupCard,
          projectGroupName,
        );

        expect(projectGroupCardFinder, findsOneWidget);
      },
    );

    testWidgets(
      "allows updating a project group",
      (WidgetTester tester) async {
        await tester.pumpAndSettleWidget(MetricsApp(
          metricsConfig: metricsConfig,
        ));
        await openProjectGroupsPage(tester);

        final projectGroupCardFinder = find.widgetWithText(
          ProjectGroupCard,
          projectGroupName,
        );

        await tester.ensureVisible(projectGroupCardFinder);
        await tester.hoverWidget(projectGroupCardFinder);

        final editButtonFinder = find.descendant(
          of: projectGroupCardFinder,
          matching: find.widgetWithText(IconLabelButton, CommonStrings.edit),
        );
        await tester.tap(editButtonFinder);
        await tester.pumpAndSettle();

        final projectGroupNameInputFinder = find.widgetWithText(
          MetricsTextFormField,
          projectGroupName,
        );
        await tester.tap(projectGroupNameInputFinder);

        await tester.enterText(
          projectGroupNameInputFinder,
          updatedProjectGroupName,
        );
        await tester.pumpAndSettle();

        final saveButtonFinder = find.widgetWithText(
          MetricsPositiveButton,
          ProjectGroupsStrings.saveChanges,
        );
        await tester.tap(saveButtonFinder);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        final updatedProjectGroupCardFinder = find.widgetWithText(
          ProjectGroupCard,
          updatedProjectGroupName,
        );

        expect(updatedProjectGroupCardFinder, findsOneWidget);
      },
    );

    testWidgets(
      "allows deleting a project group",
      (WidgetTester tester) async {
        await tester.pumpAndSettleWidget(MetricsApp(
          metricsConfig: metricsConfig,
        ));
        await openProjectGroupsPage(tester);

        final projectGroupCardFinder = find.widgetWithText(
          ProjectGroupCard,
          updatedProjectGroupName,
        );

        await tester.ensureVisible(projectGroupCardFinder);

        await tester.hoverWidget(projectGroupCardFinder);

        final deleteButtonFinder = find.descendant(
          of: projectGroupCardFinder,
          matching: find.widgetWithText(IconLabelButton, CommonStrings.delete),
        );
        await tester.tap(deleteButtonFinder);
        await tester.pumpAndSettle();

        await tester.tap(find.byType(MetricsNegativeButton));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(
          find.widgetWithText(ProjectGroupCard, projectGroupName),
          findsNothing,
        );
      },
    );
  });
}
