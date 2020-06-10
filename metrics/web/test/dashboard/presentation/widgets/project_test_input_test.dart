// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/widgets/project_search_input.dart';

void main() {
  group("ProjectSearchInput", () {
    testWidgets(
      "displays a hint text",
      (tester) async {
        await tester.pumpWidget(_ProjectSearchInputTestbed());

        expect(find.text(CommonStrings.searchForProject), findsOneWidget);
      },
    );

    testWidgets(
      "displays a search icon",
      (tester) async {
        await tester.pumpWidget(_ProjectSearchInputTestbed());

        expect(find.widgetWithIcon(TextField, Icons.search), findsOneWidget);
      },
    );

    testWidgets(
      "onChanged callback is called after entering a text",
      (tester) async {
        bool isCalled = false;

        await tester.pumpWidget(_ProjectSearchInputTestbed(
          onChanged: (_) => isCalled = true,
        ));

        await tester.enterText(find.byType(ProjectSearchInput), 'test');
        await tester.pumpAndSettle();

        expect(isCalled, equals(isTrue));
      },
    );
  });
}

@immutable
class _ProjectSearchInputTestbed extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _ProjectSearchInputTestbed({
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ProjectSearchInput(
          onChanged: onChanged,
        ),
      ),
    );
  }
}
