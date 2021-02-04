// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/loading_placeholder.dart';
import 'package:metrics/common/presentation/text_placeholder/widgets/text_placeholder.dart';
import 'package:metrics/dashboard/presentation/strings/dashboard_strings.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/view_models/project_checkbox_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/project_checkbox_list.dart';
import 'package:metrics/project_groups/presentation/widgets/project_checkbox_list_tile.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/project_groups_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("ProjectCheckboxList", () {
    testWidgets(
      "displays all given project checkbox view models",
      (WidgetTester tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        const projectCheckboxViewModels = [
          ProjectCheckboxViewModel(isChecked: false, id: 'id', name: 'name'),
          ProjectCheckboxViewModel(isChecked: false, id: 'id', name: 'name'),
          ProjectCheckboxViewModel(isChecked: false, id: 'id', name: 'name'),
        ];

        when(projectGroupsNotifier.projectCheckboxViewModels)
            .thenReturn(projectCheckboxViewModels);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_ProjectCheckboxListTestbed(
            projectGroupsNotifier: projectGroupsNotifier,
          ));
        });

        final projectCheckboxWidgets = tester.widgetList(
          find.byType(ProjectCheckboxListTile),
        );

        expect(
          projectCheckboxWidgets.length,
          equals(projectCheckboxViewModels.length),
        );
      },
    );

    testWidgets(
      "displays the text placeholder with an error message if there is a projects error",
      (WidgetTester tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();
        const error = 'error';

        when(projectGroupsNotifier.projectsErrorMessage).thenReturn(error);

        await tester.pumpWidget(
          _ProjectCheckboxListTestbed(
            projectGroupsNotifier: projectGroupsNotifier,
          ),
        );

        final textPlaceholderFinder = find.widgetWithText(
          TextPlaceholder,
          error,
        );

        expect(textPlaceholderFinder, findsOneWidget);
      },
    );

    testWidgets(
      "displays the loading placeholder if a list of project checkbox view models is null",
      (WidgetTester tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectCheckboxViewModels).thenReturn(null);

        await tester.pumpWidget(
          _ProjectCheckboxListTestbed(
            projectGroupsNotifier: projectGroupsNotifier,
          ),
        );

        expect(find.byType(LoadingPlaceholder), findsOneWidget);
      },
    );

    testWidgets(
      "displays the no configured projects placeholder if project checkbox view models are empty",
      (WidgetTester tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectCheckboxViewModels).thenReturn([]);

        await tester.pumpWidget(
          _ProjectCheckboxListTestbed(
            projectGroupsNotifier: projectGroupsNotifier,
          ),
        );

        final textPlaceholderFinder = find.widgetWithText(
          TextPlaceholder,
          DashboardStrings.noConfiguredProjects,
        );

        expect(textPlaceholderFinder, findsOneWidget);
      },
    );

    testWidgets(
      "displays the no search results placeholder if project checkbox view models are empty and filtered",
      (WidgetTester tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectCheckboxViewModels).thenReturn([]);
        when(projectGroupsNotifier.projectNameFilter).thenReturn('filter');

        await tester.pumpWidget(
          _ProjectCheckboxListTestbed(
            projectGroupsNotifier: projectGroupsNotifier,
          ),
        );

        final textPlaceholderFinder = find.widgetWithText(
          TextPlaceholder,
          ProjectGroupsStrings.noSearchResults,
        );

        expect(textPlaceholderFinder, findsOneWidget);
      },
    );
  });
}

/// A testbed widget, used to test the [ProjectCheckboxList] widget.
class _ProjectCheckboxListTestbed extends StatelessWidget {
  /// The [ProjectGroupsNotifier] to inject and use to test
  /// the [ProjectCheckboxList] widget.
  final ProjectGroupsNotifier projectGroupsNotifier;

  /// Creates the [_ProjectCheckboxListTestbed] with
  /// the given [projectGroupsNotifier].
  const _ProjectCheckboxListTestbed({
    Key key,
    this.projectGroupsNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      projectGroupsNotifier: projectGroupsNotifier,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            home: Scaffold(
              body: ProjectCheckboxList(),
            ),
          );
        },
      ),
    );
  }
}
