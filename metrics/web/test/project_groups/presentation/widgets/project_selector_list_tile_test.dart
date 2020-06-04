import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/project_groups/presentation/view_models/project_selector_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/project_selector_list_tile.dart';

import '../../../test_utils/new_test_injection_container.dart';

void main() {
  group("ProjectSelectorListTile", () {
    testWidgets(
      "contains project selector name",
      (tester) async {
        await tester.pumpWidget(_ProjectSelectorListTileTestbed());

        expect(
          find.widgetWithText(
            CheckboxListTile,
            _ProjectSelectorListTileTestbed.projectSelectorViewModel.name,
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "has a value equals to the project selector view model checked status",
      (tester) async {
        await tester.pumpWidget(_ProjectSelectorListTileTestbed());

        final checkbox = tester.widget<CheckboxListTile>(
          find.byType(CheckboxListTile),
        );

        expect(
          checkbox.value,
          _ProjectSelectorListTileTestbed.projectSelectorViewModel.isChecked,
        );
      },
    );
  });
}

/// A testbed widget used to test the [ProjectSelectorListTile] widget.
class _ProjectSelectorListTileTestbed extends StatelessWidget {
  static ProjectSelectorViewModel projectSelectorViewModel =
      ProjectSelectorViewModel(
    id: 'id',
    name: 'name',
    isChecked: false,
  );

  @override
  Widget build(BuildContext context) {
    return NewTestInjectionContainer(
      child: MaterialApp(
        home: Scaffold(
          body: ProjectSelectorListTile(
            projectSelectorViewModel: projectSelectorViewModel,
          ),
        ),
      ),
    );
  }
}
