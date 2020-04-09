import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/state/user_store.dart';
import 'package:metrics/features/common/presentation/drawer/widget/metrics_drawer.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';
import 'package:metrics/features/dashboard/presentation/model/project_metrics_data.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:metrics/features/dashboard/presentation/state/project_metrics_store.dart';
import 'package:metrics/features/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/features/dashboard/presentation/widgets/circle_percentage.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../../test_utils/metrics_store_stub.dart';

void main() {
  group("DashboardPage", () {
    testWidgets(
      "displays an error, occured during loading the metrics data",
      (WidgetTester tester) async {
        const metricsStore = MetricsStoreErrorStub();

        await tester.pumpWidget(const DashboardTestbed(
          metricsStore: metricsStore,
        ));

        await tester.pumpAndSettle();

        expect(
          find.text(DashboardStrings.getLoadingErrorMessage(
              '${MetricsStoreErrorStub.errorMessage}')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "displays the drawer on tap on menu button",
      (WidgetTester tester) async {
        await tester.pumpWidget(const DashboardTestbed());
        await tester.pumpAndSettle();

        await tester.tap(find.descendant(
          of: find.byType(AppBar),
          matching: find.byType(IconButton),
        ));
        await tester.pumpAndSettle();

        expect(find.byType(MetricsDrawer), findsOneWidget);
      },
    );

    testWidgets(
      "changes the widget theme on switching theme in the drawer",
      (WidgetTester tester) async {
        final themeStore = ThemeStore();

        await tester.pumpWidget(DashboardTestbed(
          themeStore: themeStore,
        ));
        await tester.pumpAndSettle();

        final circlePercentageTitleColor =
            _getCirclePercentageTitleColor(tester);

        await tester.tap(find.descendant(
          of: find.byType(AppBar),
          matching: find.byType(IconButton),
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(CheckboxListTile));
        await tester.pump();

        final newCirclePercentageTitleColor =
            _getCirclePercentageTitleColor(tester);

        expect(
          newCirclePercentageTitleColor,
          isNot(circlePercentageTitleColor),
        );
      },
    );

    testWidgets(
      'displays the placeholder when there are no available projects',
      (WidgetTester tester) async {
        const metricsStore = MetricsStoreStub(projectMetrics: []);
        await tester.pumpWidget(const DashboardTestbed(
          metricsStore: metricsStore,
        ));

        await tester.pumpAndSettle();

        expect(
          find.text(DashboardStrings.noConfiguredProjects),
          findsOneWidget,
        );
      },
    );
  });
}

Color _getCirclePercentageTitleColor(WidgetTester tester) {
  final circlePercentageFinder = find.descendant(
    of: find.widgetWithText(CirclePercentage, DashboardStrings.coverage),
    matching: find.text(DashboardStrings.coverage),
  );

  final titleWidget = tester.widget<Text>(
    circlePercentageFinder,
  );

  return titleWidget.style?.color;
}

class DashboardTestbed extends StatelessWidget {
  final ProjectMetricsStore metricsStore;
  final ThemeStore themeStore;

  const DashboardTestbed({
    Key key,
    this.metricsStore = const MetricsStoreStub(),
    this.themeStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Injector(
        inject: [
          Inject<ProjectMetricsStore>(() => metricsStore),
          Inject<ThemeStore>(() => themeStore ?? ThemeStore()),
          Inject<UserStore>(() => UserStore()),
        ],
        initState: () {
          Injector.getAsReactive<ProjectMetricsStore>().setState(
            (store) => store.subscribeToProjects(),
            catchError: true,
          );
          Injector.getAsReactive<ThemeStore>()
              .setState((store) => store.isDark = false);
          Injector.getAsReactive<UserStore>().setState((store) => store.subscribeToAuthenticationUpdates());
        },
        builder: (BuildContext context) => MetricsThemeBuilder(
          builder: (_, __) {
            return DashboardPage();
          },
        ),
      ),
    );
  }
}

class MetricsStoreErrorStub extends MetricsStoreStub {
  static const String errorMessage = "Unknown error";

  const MetricsStoreErrorStub();

  @override
  Stream<List<ProjectMetricsData>> get projectsMetrics => throw errorMessage;

  @override
  Future<void> subscribeToProjects() {
    throw errorMessage;
  }

  @override
  void dispose() {}
}
