import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/view_models/project_checkbox_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/project_checkbox_list_tile.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/project_groups_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("ProjectCheckboxListTile", () {
    const projectCheckboxViewModel = ProjectCheckboxViewModel(
      id: 'id',
      name: 'name',
      isChecked: false,
    );

    testWidgets(
      "throws an AssertionError if the given project checkbox view model is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ProjectCheckboxListTileTestbed(
          projectCheckboxViewModel: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the name of the project checkbox view model in the checkbox list tile",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _ProjectCheckboxListTileTestbed(
            projectCheckboxViewModel: projectCheckboxViewModel,
          ),
        );

        final checkboxListTileFinder = find.widgetWithText(
          CheckboxListTile,
          projectCheckboxViewModel.name,
        );

        expect(checkboxListTileFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the checkbox value corresponding to the project checkbox view model isChecked value",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _ProjectCheckboxListTileTestbed(
            projectCheckboxViewModel: projectCheckboxViewModel,
          ),
        );

        final widget = tester.widget<CheckboxListTile>(
          find.byType(CheckboxListTile),
        );

        expect(widget.value, equals(projectCheckboxViewModel.isChecked));
      },
    );

    testWidgets(
      "toggles the project checkbox status on tap",
      (WidgetTester tester) async {
        final projectGroupsNotifierMock = ProjectGroupsNotifierMock();

        await tester.pumpWidget(
          _ProjectCheckboxListTileTestbed(
            projectGroupsNotifier: projectGroupsNotifierMock,
            projectCheckboxViewModel: projectCheckboxViewModel,
          ),
        );

        await tester.tap(find.byType(CheckboxListTile));
        await tester.pump();

        verify(
          projectGroupsNotifierMock.toggleProjectCheckedStatus(
            projectCheckboxViewModel.id,
          ),
        ).called(equals(1));
      },
    );

    testWidgets(
      "applies a hand cursor to the checkbox list tile",
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
      child: MaterialApp(
        home: Scaffold(
          body: ProjectCheckboxListTile(
            projectCheckboxViewModel: projectCheckboxViewModel,
          ),
        ),
      ),
    );
  }
}
