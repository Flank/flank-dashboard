import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/view_models/project_checkbox_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/project_checkbox_list_tile.dart';

import '../../../test_utils/test_injection_container.dart';

void main() {
  group("ProjectCheckboxListTile", () {
    testWidgets(
      "changes the cursor style for the checkbox list tile",
      (WidgetTester tester) async {
        const projectCheckboxViewModel = ProjectCheckboxViewModel(
          id: 'id',
          name: 'name',
          isChecked: false,
        );

        await tester.pumpWidget(const _ProjectCheckboxListTileTestbed(
          projectCheckboxViewModel: projectCheckboxViewModel,
        ));

        final finder = find.ancestor(
          of: find.byType(CheckboxListTile),
          matching: find.byType(HandCursor),
        );

        expect(finder, findsOneWidget);
      },
    );
  });
}

/// A testbed class required to test the [ProjectCheckboxListTile] widget.
class _ProjectCheckboxListTileTestbed extends StatelessWidget {
  /// A [ProjectGroupsNotifier] that will be injected and used in tests.
  final ProjectGroupsNotifier projectGroupsNotifier;

  /// A view model with the data to display within this widget.
  final ProjectCheckboxViewModel projectCheckboxViewModel;

  /// Creates a new instance of the [_ProjectCheckboxListTileTestbed]
  /// with the given [projectCheckboxViewModel].
  const _ProjectCheckboxListTileTestbed({
    Key key,
    this.projectCheckboxViewModel,
    this.projectGroupsNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      projectGroupsNotifier: projectGroupsNotifier,
      child: ProjectCheckboxListTile(
        projectCheckboxViewModel: projectCheckboxViewModel,
      ),
    );
  }
}
