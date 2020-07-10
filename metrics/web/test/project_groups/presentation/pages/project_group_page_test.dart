import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/project_groups/presentation/pages/project_group_page.dart';
import 'package:metrics/project_groups/presentation/state/project_groups_notifier.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_view.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/project_groups_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("ProjectGroupPage", () {
    testWidgets(
      "subscribes to project groups updates in initState",
      (tester) async {
        final notifier = ProjectGroupsNotifierMock();

        await mockNetworkImagesFor(() => tester.pumpWidget(
              _ProjectGroupPageTestbed(projectGroupsNotifier: notifier),
            ));

        verify(notifier.subscribeToProjectGroups()).called(equals(1));
      },
    );

    testWidgets(
      "displays the project group text",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpWidget(const _ProjectGroupPageTestbed()),
        );

        expect(
          find.text(CommonStrings.projectGroups),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "contains the project group view",
      (WidgetTester tester) async {
        await mockNetworkImagesFor(
          () => tester.pumpWidget(const _ProjectGroupPageTestbed()),
        );

        expect(find.byType(ProjectGroupView), findsOneWidget);
      },
    );

    testWidgets(
      "unsubscribes from project groups on dispose",
      (WidgetTester tester) async {
        final key = GlobalKey<NavigatorState>();
        final notifier = ProjectGroupsNotifierMock();

        await mockNetworkImagesFor(
          () => tester.pumpWidget(_ProjectGroupPageTestbed(
            navigatorKey: key,
            projectGroupsNotifier: notifier,
          )),
        );

        key.currentState.pop();
        await tester.pumpAndSettle();

        verify(notifier.unsubscribeFromProjectGroups()).called(equals(1));
      },
    );
  });
}

/// A testbed widget, used to test the [ProjectGroupPage] widget.
class _ProjectGroupPageTestbed extends StatelessWidget {
  /// The [ProjectGroupsNotifier] to inject and use to test the [ProjectGroupPage].
  final ProjectGroupsNotifier projectGroupsNotifier;

  /// A [GlobalKey] used to get a [NavigatorState] in tests.
  final GlobalKey<NavigatorState> navigatorKey;

  /// Creates the [_ProjectGroupPageTestbed] with the given [projectGroupsNotifier].
  const _ProjectGroupPageTestbed({
    Key key,
    this.projectGroupsNotifier,
    this.navigatorKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      projectGroupsNotifier: projectGroupsNotifier,
      child: MetricsThemedTestbed(
        navigatorKey: navigatorKey,
        body: ProjectGroupPage(),
      ),
    );
  }
}
