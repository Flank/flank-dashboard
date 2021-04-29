// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/loading_placeholder.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_card_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_card.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_view.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/project_groups_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("ProjectGroupView", () {
    const List<ProjectGroupCardViewModel> projectGroupCardViewModels = [
      ProjectGroupCardViewModel(id: 'id1', name: 'name1', projectsCount: 0),
      ProjectGroupCardViewModel(id: 'id2', name: 'name2', projectsCount: 1),
      ProjectGroupCardViewModel(id: 'id3', name: 'name3', projectsCount: 2),
    ];

    testWidgets(
      "displays the project groups error message if it is not null",
      (tester) async {
        const errorMessage = 'error';
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectGroupsErrorMessage)
            .thenReturn(errorMessage);

        await tester.pumpWidget(
          _ProjectGroupViewTestbed(
            projectGroupsNotifier: projectGroupsNotifier,
          ),
        );

        expect(
          find.text(errorMessage),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "displays the loading placeholder if project group card view models are null",
      (tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectGroupCardViewModels).thenReturn(null);

        await tester.pumpWidget(
          _ProjectGroupViewTestbed(
            projectGroupsNotifier: projectGroupsNotifier,
          ),
        );

        expect(find.byType(LoadingPlaceholder), findsOneWidget);
      },
    );

    testWidgets(
      "wraps content",
      (tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectGroupCardViewModels)
            .thenReturn(projectGroupCardViewModels);
        when(projectGroupsNotifier.hasConfiguredProjects).thenReturn(true);

        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            _ProjectGroupViewTestbed(
              projectGroupsNotifier: projectGroupsNotifier,
            ),
          ),
        );

        expect(
          find.descendant(
            of: find.byType(Wrap),
            matching: find.byType(ProjectGroupCard),
          ),
          findsWidgets,
        );
      },
    );

    testWidgets(
      "contains the add project group card widget",
      (tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectGroupCardViewModels)
            .thenReturn(projectGroupCardViewModels);
        when(projectGroupsNotifier.hasConfiguredProjects).thenReturn(true);

        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            _ProjectGroupViewTestbed(
              projectGroupsNotifier: projectGroupsNotifier,
            ),
          ),
        );

        expect(find.byType(AddProjectGroupCard), findsWidgets);
      },
    );

    testWidgets(
      "displays the add project group card widget before any other project group card widgets",
      (tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectGroupCardViewModels)
            .thenReturn(projectGroupCardViewModels);
        when(projectGroupsNotifier.hasConfiguredProjects).thenReturn(true);

        await mockNetworkImagesFor(
          () => tester.pumpWidget(
            _ProjectGroupViewTestbed(
              projectGroupsNotifier: projectGroupsNotifier,
            ),
          ),
        );

        final firstWidget =
            tester.widget<Wrap>(find.byType(Wrap)).children.first;

        expect(firstWidget, isA<AddProjectGroupCard>());
      },
    );

    testWidgets(
      "displays a list of project group card view models as project group card widgets",
      (tester) async {
        final projectGroupsNotifier = ProjectGroupsNotifierMock();

        when(projectGroupsNotifier.projectGroupCardViewModels)
            .thenReturn(projectGroupCardViewModels);
        when(projectGroupsNotifier.hasConfiguredProjects).thenReturn(true);

        await tester.pumpWidget(_ProjectGroupViewTestbed(
          projectGroupsNotifier: projectGroupsNotifier,
        ));

        final projectGroupCardWidgets =
            tester.widgetList<ProjectGroupCard>(find.byType(ProjectGroupCard));

        final actualProjectGroupCardViewModels = projectGroupCardWidgets
            .map((card) => card.projectGroupCardViewModel)
            .toList();

        expect(
          actualProjectGroupCardViewModels,
          equals(projectGroupCardViewModels),
        );
      },
    );
  });
}

/// A testbed widget, used to test the [ProjectGroupView] widget.
class _ProjectGroupViewTestbed extends StatelessWidget {
  /// A [ProjectGroupsNotifier] used in tests.
  final ProjectGroupsNotifier projectGroupsNotifier;

  /// Creates a new instance of the [_ProjectGroupViewTestbed] with
  /// the given [projectGroupsNotifier].
  const _ProjectGroupViewTestbed({
    Key key,
    this.projectGroupsNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      projectGroupsNotifier: projectGroupsNotifier,
      child: MaterialApp(
        home: Scaffold(
          body: ProjectGroupView(),
        ),
      ),
    );
  }
}
