import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/widgets/loading_placeholder.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_placeholder.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/widgets/project_selector_list.dart';
import 'package:metrics/project_groups/presentation/widgets/project_selector_list_tile.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/project_group_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("ProjectSelectorList", () {
    testWidgets(
      "contains ProjectSelectorListTile widgets",
      (tester) async {
        await tester.pumpWidget(const _ProjectSelectorListTestbed());

        expect(
          find.byType(ProjectSelectorListTile),
          findsWidgets,
        );
      },
    );

    testWidgets(
      "displays a projects error message if something went wrong",
      (tester) async {
        const errorText = 'error text';
        final projectGroupsNotifierMock = ProjectGroupsNotifierMock();
        when(projectGroupsNotifierMock.projectsErrorMessage)
            .thenReturn(errorText);

        await tester.pumpWidget(_ProjectSelectorListTestbed(
          projectGroupsNotifier: projectGroupsNotifierMock,
        ));

        expect(
          find.text(errorText),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "displays a loading placeholder if project selector view models are null",
      (tester) async {
        final projectGroupsNotifierMock = ProjectGroupsNotifierMock();
        when(projectGroupsNotifierMock.projectSelectorViewModels)
            .thenReturn(null);

        await tester.pumpWidget(_ProjectSelectorListTestbed(
          projectGroupsNotifier: projectGroupsNotifierMock,
        ));

        expect(
          find.byType(LoadingPlaceholder),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "displays the text placeholder if project selector view models are empty",
      (tester) async {
        final projectGroupsNotifierMock = ProjectGroupsNotifierMock();
        when(projectGroupsNotifierMock.projectSelectorViewModels)
            .thenReturn([]);

        await tester.pumpWidget(_ProjectSelectorListTestbed(
          projectGroupsNotifier: projectGroupsNotifierMock,
        ));

        expect(
          find.widgetWithText(
            MetricsTextPlaceholder,
            DashboardStrings.noConfiguredProjects,
          ),
          findsOneWidget,
        );
      },
    );
  });
}

/// A testbed widget used to test the [ProjectSelectorListTile] widget.
class _ProjectSelectorListTestbed extends StatelessWidget {
  final ProjectGroupsNotifier projectGroupsNotifier;

  const _ProjectSelectorListTestbed({
    Key key,
    this.projectGroupsNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      projectGroupsNotifier: projectGroupsNotifier,
      child: MaterialApp(
        home: Scaffold(
          body: ProjectSelectorList(),
        ),
      ),
    );
  }
}
