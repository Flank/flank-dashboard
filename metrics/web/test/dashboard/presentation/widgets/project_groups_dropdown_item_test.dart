import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dropdown_item_theme_data.dart';
import 'package:metrics/dashboard/presentation/view_models/project_group_dropdown_item_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/project_groups_dropdown_item.dart';

import '../../../test_utils/metrics_themed_testbed.dart';

void main() {
  group("ProjectGroupsDropdownItem", () {
    const backgroundColor = Colors.red;
    const hoverColor = Colors.grey;
    const textStyle = TextStyle(fontSize: 13.0);

    const theme = MetricsThemeData(
      dropdownItemTheme: DropdownItemThemeData(
        backgroundColor: backgroundColor,
        hoverColor: hoverColor,
        textStyle: textStyle,
      ),
    );

    final containerFinder = find.descendant(
      of: find.byType(ProjectGroupsDropdownItem),
      matching: find.byType(Container),
    );

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
      "applies the item background color from the metrics theme if the widget is not hovered",
      (tester) async {
        const expectedDecoration = BoxDecoration(color: backgroundColor);

        await tester.pumpWidget(const _ProjectGroupsDropdownTestbed(
          projectGroupDropdownItemViewModel: projectGroupDropdownItemViewModel,
          theme: theme,
        ));

        final container = tester.widget<Container>(containerFinder);

        expect(container.decoration, equals(expectedDecoration));
      },
    );

    testWidgets(
      "applies the hover color from the metrics theme if the widget is hovered",
      (tester) async {
        const boxDecoration = BoxDecoration(color: hoverColor);

        await tester.pumpWidget(const _ProjectGroupsDropdownTestbed(
          projectGroupDropdownItemViewModel: projectGroupDropdownItemViewModel,
          theme: theme,
        ));

        final mouseRegion = tester.widget<MouseRegion>(find.descendant(
          of: find.byType(ProjectGroupsDropdownItem),
          matching: find.byType(MouseRegion).last,
        ));

        const pointerEnterEvent = PointerEnterEvent();
        mouseRegion.onEnter(pointerEnterEvent);
        await tester.pump();

        final container = tester.widget<Container>(containerFinder);

        expect(container.decoration, equals(boxDecoration));
      },
    );

    testWidgets(
      "applies the text style from the metrics theme",
      (tester) async {
        await tester.pumpWidget(const _ProjectGroupsDropdownTestbed(
          projectGroupDropdownItemViewModel: projectGroupDropdownItemViewModel,
          theme: theme,
        ));

        final textWidget = tester.widget<Text>(
          find.text(projectGroupDropdownItemViewModel.name),
        );

        expect(textWidget.style, equals(textStyle));
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

  /// A [MetricsThemeData] used in this testbed.
  final MetricsThemeData theme;

  /// Creates an instance of this testbed
  /// with the given [projectGroupDropdownItemViewModel] and the [theme].
  const _ProjectGroupsDropdownTestbed({
    Key key,
    this.projectGroupDropdownItemViewModel,
    this.theme = const MetricsThemeData(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetricsThemedTestbed(
      metricsThemeData: theme,
      body: ProjectGroupsDropdownItem(
        projectGroupDropdownItemViewModel: projectGroupDropdownItemViewModel,
      ),
    );
  }
}
