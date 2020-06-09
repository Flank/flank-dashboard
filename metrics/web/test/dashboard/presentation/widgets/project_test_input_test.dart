// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/widgets/project_search_input.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/project_metrics_notifier_mock.dart';
import '../../../test_utils/project_metrics_notifier_stub.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("ProjectSearchInput", () {
    testWidgets(
      "displays a hint text",
      (tester) async {
        await tester.pumpWidget(_ProjectSearchInputTestbed());

        expect(find.text(CommonStrings.searchForProject), findsOneWidget);
      },
    );

    testWidgets(
      "displays a search icon",
      (tester) async {
        await tester.pumpWidget(_ProjectSearchInputTestbed());

        expect(find.widgetWithIcon(TextField, Icons.search), findsOneWidget);
      },
    );

    testWidgets(
      "calls the filterByProjectName method of the ProjectMetricsNotifier after entering text",
      (tester) async {
        final metricsNotifier = ProjectMetricsNotifierMock();

        await tester.pumpWidget(_ProjectSearchInputTestbed(
          metricsNotifier: metricsNotifier,
        ));

        await tester.runAsync(() async {
          await tester.enterText(find.byType(ProjectSearchInput), 'test');
          await tester.pumpAndSettle();
        });

        verify(metricsNotifier.filterByProjectName(any)).called(1);
      },
    );
  });
}

@immutable
class _ProjectSearchInputTestbed extends StatelessWidget {
  final ProjectMetricsNotifier metricsNotifier;

  const _ProjectSearchInputTestbed({
    this.metricsNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final notifier = metricsNotifier ?? ProjectMetricsNotifierStub();

    return TestInjectionContainer(
      metricsNotifier: notifier,
      child: MaterialApp(
        home: Scaffold(
          body: ProjectSearchInput(
            onFilter: notifier.filterByProjectName,
          ),
        ),
      ),
    );
  }
}
