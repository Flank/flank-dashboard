// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_dialog_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/strategy/add_project_group_dialog_strategy.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/project_groups_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("AddProjectGroupDialog", () {
    testWidgets(
      "displays the ProjectGroupDialog with the add project group strategy",
      (tester) async {
        final projectGroup = ProjectGroupDialogViewModel(
          id: 'id',
          name: 'name',
          selectedProjectIds: UnmodifiableListView([]),
        );
        final notifierMock = ProjectGroupsNotifierMock();
        when(notifierMock.projectGroupDialogViewModel).thenReturn(projectGroup);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(_AddProjectGroupDialogTestbed(
            projectGroupsNotifier: notifierMock,
          ));
        });

        final projectDialog = tester.widget<ProjectGroupDialog>(
          find.byType(ProjectGroupDialog),
        );
        final strategy = projectDialog?.strategy;

        expect(strategy, isNotNull);
        expect(strategy, isA<AddProjectGroupDialogStrategy>());
      },
    );
  });
}

/// A testbed class required for testing the [AddProjectGroupDialog].
class _AddProjectGroupDialogTestbed extends StatelessWidget {
  /// A [ProjectGroupsNotifier] that will be injected and used in tests.
  final ProjectGroupsNotifier projectGroupsNotifier;

  /// Creates a new instance of the [_AddProjectGroupDialogTestbed]
  /// with the given [projectGroupsNotifier].
  const _AddProjectGroupDialogTestbed({
    Key key,
    this.projectGroupsNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      projectGroupsNotifier: projectGroupsNotifier,
      child: MetricsThemedTestbed(
        body: AddProjectGroupDialog(),
      ),
    );
  }
}
