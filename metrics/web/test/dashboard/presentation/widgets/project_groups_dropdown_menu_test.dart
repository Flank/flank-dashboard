import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/dropdown_menu.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:metrics/dashboard/presentation/view_models/project_group_dropdown_item_view_model.dart';
import 'package:metrics/dashboard/presentation/widgets/project_groups_dropdown_body.dart';
import 'package:metrics/dashboard/presentation/widgets/project_groups_dropdown_item.dart';
import 'package:metrics/dashboard/presentation/widgets/project_groups_dropdown_menu.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/project_metrics_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("ProjectGroupsDropdownMenu", () {
    ProjectMetricsNotifier metricsNotifier;

    const firstDropdownItem = ProjectGroupDropdownItemViewModel(
      id: '1',
      name: 'name1',
    );

    const secondDropdownItem = ProjectGroupDropdownItemViewModel(
      id: '2',
      name: 'name2',
    );

    const dropdownItems = [firstDropdownItem, secondDropdownItem];

    setUp(() {
      metricsNotifier = ProjectMetricsNotifierMock();
      when(metricsNotifier.projectGroupDropdownItems).thenReturn(dropdownItems);
    });

    final dropdownMenuFinder = find.byWidgetPredicate(
      (widget) => widget is DropdownMenu,
    );

    testWidgets(
      "contains the dropdown menu widget",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _ProjectGroupsDropdownMenuTestbed(metricsNotifier: metricsNotifier),
          );
        });

        expect(
          dropdownMenuFinder,
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "does not overflow on a very long project group name",
      (tester) async {
        when(metricsNotifier.projectGroupDropdownItems).thenReturn(const [
          ProjectGroupDropdownItemViewModel(
            name:
                'Some very long name to test that project groups dropdown menu widget does not overflows with a very long text in it',
          ),
        ]);

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _ProjectGroupsDropdownMenuTestbed(metricsNotifier: metricsNotifier),
          );
        });

        expect(
          tester.takeException(),
          isNull,
        );
      },
    );

    testWidgets(
      "applies the project group dropdown items to the dropdown menu widget",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _ProjectGroupsDropdownMenuTestbed(metricsNotifier: metricsNotifier),
          );
        });

        final dropdownMenu = tester.widget<DropdownMenu>(dropdownMenuFinder);

        expect(dropdownMenu.items, equals(dropdownItems));
      },
    );

    testWidgets(
      "selects the first item initially",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _ProjectGroupsDropdownMenuTestbed(metricsNotifier: metricsNotifier),
          );
        });

        final selectedItemFinder = find.descendant(
          of: find.byType(ProjectGroupsDropdownMenu),
          matching: find.text(firstDropdownItem.name),
        );

        expect(selectedItemFinder, findsOneWidget);
      },
    );

    testWidgets(
      "displays a project groups dropdown body when opened",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _ProjectGroupsDropdownMenuTestbed(metricsNotifier: metricsNotifier),
          );
        });

        await tester.tap(find.byType(ProjectGroupsDropdownMenu));
        await tester.pumpAndSettle();

        expect(find.byType(ProjectGroupsDropdownBody), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given items with the ProjectGroupDropdownItem widget",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _ProjectGroupsDropdownMenuTestbed(metricsNotifier: metricsNotifier),
          );
        });

        await tester.tap(find.byType(ProjectGroupsDropdownMenu));
        await tester.pumpAndSettle();

        final actualDropdownItems = tester
            .widgetList<ProjectGroupsDropdownItem>(
              find.byType(ProjectGroupsDropdownItem),
            )
            .map((item) => item.projectGroupDropdownItemViewModel)
            .toList();

        expect(listEquals(actualDropdownItems, dropdownItems), isTrue);
      },
    );

    testWidgets(
      "displays the selected project group",
      (tester) async {
        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _ProjectGroupsDropdownMenuTestbed(metricsNotifier: metricsNotifier),
          );
        });

        await tester.tap(find.byType(ProjectGroupsDropdownMenu));
        await tester.pumpAndSettle();

        await tester.tap(find.text(secondDropdownItem.name));

        await tester.pumpAndSettle();

        expect(find.text(secondDropdownItem.name), findsOneWidget);
      },
    );

    testWidgets(
      "displays a dropdown button that contains the dropdown icon",
      (tester) async {
        const expectedImage = NetworkImage("icons/dropdown.svg");

        await mockNetworkImagesFor(() {
          return tester.pumpWidget(
            _ProjectGroupsDropdownMenuTestbed(metricsNotifier: metricsNotifier),
          );
        });

        final imageFinder = find.descendant(
          of: find.byType(ProjectGroupsDropdownMenu),
          matching: find.byType(Image),
        );

        final actualImage = tester.widget<Image>(imageFinder)?.image;

        expect(actualImage, equals(expectedImage));
      },
    );
  });
}

/// A testbed class used to test the [ProjectGroupsDropdownMenu] widget.
class _ProjectGroupsDropdownMenuTestbed extends StatelessWidget {
  /// A [ProjectMetricsNotifier] used in tests.
  final ProjectMetricsNotifier metricsNotifier;

  /// Creates the testbed with the given [metricsNotifier].
  const _ProjectGroupsDropdownMenuTestbed({
    Key key,
    this.metricsNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      metricsNotifier: metricsNotifier,
      child: MetricsThemedTestbed(
        body: ProjectGroupsDropdownMenu(),
      ),
    );
  }
}
