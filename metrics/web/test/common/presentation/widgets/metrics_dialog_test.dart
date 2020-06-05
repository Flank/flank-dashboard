import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/widgets/metrics_dialog.dart';

void main() {
  group("MetricsDialog", () {
    const title = 'title';
    const maxWidth = 100.0;
    const content = 'content';

    testWidgets("displays the given title", (tester) async {
      await tester.pumpWidget(
        _MetricsDialogTestbed(
          title: const Text(title),
          content: Container(),
          actions: const [],
          maxWidth: maxWidth,
        ),
      );

      expect(find.text(title), findsOneWidget);
    });

    testWidgets("displays the given title", (tester) async {
      await tester.pumpWidget(
        const _MetricsDialogTestbed(
          title: Text(title),
          content: Text(content),
          actions: [],
          maxWidth: maxWidth,
        ),
      );

      expect(find.text(content), findsOneWidget);
    });

    testWidgets("displays the given actions", (tester) async {
      const firstAction = 'action1';
      const secondAction = 'action2';

      await tester.pumpWidget(
        const _MetricsDialogTestbed(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[Text(firstAction), Text(secondAction)],
          maxWidth: maxWidth,
        ),
      );

      expect(find.text(firstAction), findsOneWidget);
      expect(find.text(secondAction), findsOneWidget);
    });
  });
}

/// A testbed widget, used to test the [MetricsDialog] widget.
class _MetricsDialogTestbed extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget> actions;
  final double maxWidth;

  const _MetricsDialogTestbed({
    Key key,
    this.title,
    this.content,
    this.actions,
    this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MetricsDialog(
          title: title,
          content: content,
          actions: actions,
          maxWidth: maxWidth,
        ),
      ),
    );
  }
}
