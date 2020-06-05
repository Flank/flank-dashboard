import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_tile_card.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/view_models/project_group_card_view_model.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_card.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_delete_dialog.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_dialog.dart';

import '../../../test_utils/test_injection_container.dart';

void main() {
  group("ProjectGroupCard", () {
    testWidgets(
      "contains MetricsTileCard widget",
      (tester) async {
        await tester.pumpWidget(_ProjectGroupCardTestbed());

        expect(find.byType(MetricsTileCard), findsOneWidget);
      },
    );

    testWidgets(
      "contains project group name",
      (tester) async {
        await tester.pumpWidget(_ProjectGroupCardTestbed());

        expect(
          find.text(_ProjectGroupCardTestbed.projectGroupCardViewModel.name),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "contains project group count",
      (tester) async {
        await tester.pumpWidget(_ProjectGroupCardTestbed());

        final projectsCountText = ProjectGroupsStrings.getProjectsCount(
          _ProjectGroupCardTestbed.projectGroupCardViewModel.projectsCount,
        );

        expect(
          find.text(projectsCountText),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "contains edit button with an edit text",
      (tester) async {
        await tester.pumpWidget(_ProjectGroupCardTestbed());

        expect(
          find.widgetWithText(RawMaterialButton, CommonStrings.edit),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "contains delete button with an delete text",
      (tester) async {
        await tester.pumpWidget(_ProjectGroupCardTestbed());

        expect(
          find.widgetWithText(RawMaterialButton, CommonStrings.delete),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "opens the edit project group dialog on tap on edit button",
      (tester) async {
        await tester.pumpWidget(_ProjectGroupCardTestbed());

        final editButton = find.widgetWithText(
          RawMaterialButton,
          CommonStrings.edit,
        );

        await tester.tap(editButton);
        await tester.pump();

        expect(
          find.byType(ProjectGroupDialog),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      "opens the delete project group dialog on tap on delete button",
      (tester) async {
        await tester.pumpWidget(_ProjectGroupCardTestbed());

        final deleteButton = find.widgetWithText(
          RawMaterialButton,
          CommonStrings.delete,
        );

        await tester.tap(deleteButton);
        await tester.pumpAndSettle();

        expect(
          find.byType(ProjectGroupDeleteDialog),
          findsOneWidget,
        );
      },
    );
  });
}

/// A testbed widget used to test the [ProjectGroupCard] widget.
class _ProjectGroupCardTestbed extends StatelessWidget {
  static ProjectGroupCardViewModel projectGroupCardViewModel =
      ProjectGroupCardViewModel(
    id: 'id',
    name: 'name',
    projectsCount: 2,
  );

  @override
  Widget build(BuildContext context) {
    return TestInjectionContainer(
      child: MaterialApp(
        home: Scaffold(
          body: ProjectGroupCard(
            projectGroupCardViewModel: projectGroupCardViewModel,
          ),
        ),
      ),
    );
  }
}
