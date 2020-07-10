import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/dashboard/presentation/view_models/project_group_dropdown_item_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/project_group_dropdown_item.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("ProjectGroupDropdownItem", () {
    const projectGroupDropdownItemViewModel = ProjectGroupDropdownItemViewModel(
      id: 'id',
      name: 'name',
    );

    final mouseRegionFinder = find.descendant(
      of: find.byType(ProjectGroupDropdownItem),
      matching: find.byType(MouseRegion),
    );

    final containerFinder = find.descendant(
      of: find.byType(ProjectGroupDropdownItem),
      matching: find.byType(Container),
    );

    testWidgets(
      "throws an AssertionError if the given projectGroupDropdownItemViewModel is null",
      (tester) async {
        await tester.pumpWidget(const _ProjectGroupDropdownTestbed(
          projectGroupDropdownItemViewModel: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays a name of the given projectGroupDropdownItemViewModel",
      (tester) async {
        await tester.pumpWidget(const _ProjectGroupDropdownTestbed(
          projectGroupDropdownItemViewModel: projectGroupDropdownItemViewModel,
        ));

        expect(
          find.text(projectGroupDropdownItemViewModel.name),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "changes a background color if the widget is hovered",
      (tester) async {
        await tester.pumpWidget(const _ProjectGroupDropdownTestbed(
          projectGroupDropdownItemViewModel: projectGroupDropdownItemViewModel,
        ));

        Container container = tester.widget<Container>(containerFinder);

        final initialBoxDecoration = container.decoration;

        final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder);
        const pointerEnterEvent = PointerEnterEvent();
        mouseRegion.onEnter(pointerEnterEvent);

        await tester.pump();

        container = tester.widget<Container>(containerFinder);

        expect(container.decoration, isNot(equals(initialBoxDecoration)));
      },
    );
  });
}

/// A testbed class required to test the [ProjectGroupDropdownItem] widget.
class _ProjectGroupDropdownTestbed extends StatelessWidget {
  /// The [ProjectGroupDropdownItemViewModel] instance to display.
  final ProjectGroupDropdownItemViewModel projectGroupDropdownItemViewModel;

  /// Creates an instance of this testbed
  /// with the given [projectGroupDropdownItemViewModel].
  const _ProjectGroupDropdownTestbed({
    Key key,
    this.projectGroupDropdownItemViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      body: ProjectGroupDropdownItem(
        projectGroupDropdownItemViewModel: projectGroupDropdownItemViewModel,
      ),
    );
  }
}
