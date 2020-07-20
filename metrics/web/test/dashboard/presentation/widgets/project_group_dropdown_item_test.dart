import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/dashboard/presentation/view_models/project_group_dropdown_item_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/project_groups_dropdown_item.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("ProjectGroupsDropdownItem", () {
    const projectGroupDropdownItemViewModel = ProjectGroupDropdownItemViewModel(
      id: 'id',
      name: 'name',
    );

    testWidgets(
      "throws an AssertionError if the given project group dropdown item view model is null",
      (tester) async {
        await tester.pumpWidget(const _ProjectGroupsDropdownTestbed(
          projectGroupDropdownItemViewModel: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays a name of the given project group",
      (tester) async {
        await tester.pumpWidget(const _ProjectGroupsDropdownTestbed(
          projectGroupDropdownItemViewModel: projectGroupDropdownItemViewModel,
        ));

        expect(
          find.text(projectGroupDropdownItemViewModel.name),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "does not overflow on a very long project group name",
      (tester) async {
        const projectGroupDropdownItemViewModel =
            ProjectGroupDropdownItemViewModel(
          name:
              "very long name to test that the widget does not overflows if the name of the project group is very long",
        );

        await tester.pumpWidget(const _ProjectGroupsDropdownTestbed(
          projectGroupDropdownItemViewModel: projectGroupDropdownItemViewModel,
        ));

        expect(
          tester.takeException(),
          isNull,
        );
      },
    );
  });
}

/// A testbed class required to test the [ProjectGroupsDropdownItem] widget.
class _ProjectGroupsDropdownTestbed extends StatelessWidget {
  /// The [ProjectGroupDropdownItemViewModel] instance to display.
  final ProjectGroupDropdownItemViewModel projectGroupDropdownItemViewModel;

  /// Creates an instance of this testbed
  /// with the given [projectGroupDropdownItemViewModel].
  const _ProjectGroupsDropdownTestbed({
    Key key,
    this.projectGroupDropdownItemViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: ProjectGroupsDropdownItem(
        projectGroupDropdownItemViewModel: projectGroupDropdownItemViewModel,
      ),
    );
  }
}
