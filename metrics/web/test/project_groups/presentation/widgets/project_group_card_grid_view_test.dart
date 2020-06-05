import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_card_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_card.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card_grid_view.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/project_group_notifier_mock.dart';
import '../../../test_utils/test_injection_container.dart';

void main() {
  group("ProjectGroupCardGridView", () {
    final projectGroupsNotifierMock = ProjectGroupsNotifierMock();

    setUp(() {
      when(projectGroupsNotifierMock.projectGroupCardViewModels).thenReturn([
        ProjectGroupCardViewModel(
          projectsCount: 1,
          name: 'test',
          id: 'test',
        )
      ]);
    });

    tearDown((){
      reset(projectGroupsNotifierMock);
    });

    testWidgets(
      "contains ProjectGroupCard widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(_ProjectGroupCardGridViewTestbed(
          projectGroupsNotifierMock: projectGroupsNotifierMock,
        ));

        expect(find.byType(ProjectGroupCard), findsWidgets);
      },
    );

    testWidgets(
      "contains AddProjectGroupCard widget",
      (WidgetTester tester) async {
        await tester.pumpWidget(_ProjectGroupCardGridViewTestbed(
          projectGroupsNotifierMock: projectGroupsNotifierMock,
        ));

        expect(find.byType(AddProjectGroupCard), findsOneWidget);
      },
    );
  });
}

/// A testbed widget used to test the [ProjectGroupCardGridView] widget.
class _ProjectGroupCardGridViewTestbed extends StatelessWidget {
  final ProjectGroupsNotifierMock projectGroupsNotifierMock;

  const _ProjectGroupCardGridViewTestbed(
      {Key key, this.projectGroupsNotifierMock})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      projectGroupsNotifier: projectGroupsNotifierMock,
      child: MaterialApp(
        home: Scaffold(
          body: ProjectGroupCardGridView(),
        ),
      ),
    );
  }
}
