import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:metrics/common/presentation/widgets/metrics_button_card.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';
import 'package:metrics/project_groups/presentation/widgets/add_project_group_card.dart';
import 'package:metrics/project_groups/presentation/widgets/project_group_dialog.dart';

import '../../../test_utils/metrics_themed_testbed.dart';
import '../../../test_utils/new_test_injection_container.dart';

void main() {
  group("AddProjectGroupCard", () {
    testWidgets(
      "displays a MetricsButtonCard",
      (tester) async {
        await tester.pumpWidget(const _AddProjectGroupCardTestbed());

        expect(find.byType(MetricsButtonCard), findsOneWidget);
      },
    );

    testWidgets("changes a background color according to the active theme",
        (tester) async {
      final themeNotifier = ThemeNotifier();
      await tester.pumpWidget(
        _AddProjectGroupCardTestbed(themeNotifier: themeNotifier),
      );

      final darkMetricsButtonCard = tester.widget<MetricsButtonCard>(
        find.byType(MetricsButtonCard),
      );

      expect(darkMetricsButtonCard.backgroundColor, Colors.grey[900]);

      themeNotifier.changeTheme();
      await tester.pump();

      final lightMetricsButtonCard = tester.widget<MetricsButtonCard>(
        find.byType(MetricsButtonCard),
      );

      expect(lightMetricsButtonCard.backgroundColor, Colors.grey[200]);
    });

    testWidgets(
      "displays the add icon",
      (tester) async {
        await tester.pumpWidget(const _AddProjectGroupCardTestbed());

        expect(find.byIcon(Icons.add), findsOneWidget);
      },
    );

    testWidgets(
      "displays the add project group text",
      (tester) async {
        await tester.pumpWidget(const _AddProjectGroupCardTestbed());

        expect(find.text(ProjectGroupsStrings.addProjectGroup), findsOneWidget);
      },
    );

    testWidgets(
      "opens an add project groups dialog on tap on the card",
      (tester) async {
        await tester.pumpWidget(const _AddProjectGroupCardTestbed());

        await tester.tap(find.byType(AddProjectGroupCard));

        await tester.pumpAndSettle();

        expect(find.byType(ProjectGroupDialog), findsOneWidget);
        expect(find.text(ProjectGroupsStrings.createGroup), findsOneWidget);
      },
    );
  });
}

/// A testbed widget used to test the [AddProjectGroupCard] widget.
class _AddProjectGroupCardTestbed extends StatelessWidget {
  /// A [ThemeNotifier] that will injected and used in tests.
  final ThemeNotifier themeNotifier;

  /// Creates the [_AddProjectGroupCardTestbed] with the given [themeNotifier].
  const _AddProjectGroupCardTestbed({
    Key key,
    this.themeNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NewTestInjectionContainer(
      themeNotifier: themeNotifier,
      child: MetricsThemedTestbed(
        body: AddProjectGroupCard(),
      ),
    );
  }
}
