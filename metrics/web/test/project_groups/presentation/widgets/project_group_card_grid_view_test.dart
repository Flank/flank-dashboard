import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_card.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card_grid_view.dart';

import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/new_test_injection_container.dart';

void main() {
  group("ProjectGroupCardGridView", () {
    // testWidgets(
    //   "contains ProjectGroupCard widget",
    //   (WidgetTester tester) async {
    //     await tester.pumpWidget(_ProjectGroupCardGridViewTestbed());

    //     expect(find.byType(ProjectGroupCard), findsWidgets);
    //   },
    // );

    // testWidgets(
    //   "contains AddProjectGroupCard widget",
    //   (WidgetTester tester) async {
    //     await tester.pumpWidget(_ProjectGroupCardGridViewTestbed());

    //     expect(find.byType(AddProjectGroupCard), findsOneWidget);
    //   },
    // );
  });
}

/// A testbed widget used to test the [ProjectGroupCardGridView] widget.
class _ProjectGroupCardGridViewTestbed extends StatelessWidget {
  /// Creates the [_AddProjectGroupCardTestbed] with the given [themeNotifier].
  // const _AddProjectGroupCardTestbed({
  //   Key key,
  //   this.themeNotifier,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NewTestInjectionContainer(
      child: MaterialApp(
        home: Scaffold(
          body: ProjectGroupCardGridView(),
        ),
      ),
    );
  }
}
