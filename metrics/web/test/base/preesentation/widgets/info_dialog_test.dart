import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/info_dialog.dart';

void main() {
  group("InfoDialog", () {
    const content = Text('content text');
    const padding = EdgeInsets.all(10.0);
    const text = Text("text");
    const actions = [Text("Action")];

    testWidgets(
      "throws an AssertionError if the given title is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(
            title: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given actions is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(
            title: text,
            actions: null,
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "displays the given title",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(
            title: text,
          ),
        );

        expect(find.byWidget(text), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given background color to the dialog",
      (WidgetTester tester) async {
        const backgroundColor = Colors.red;

        await tester.pumpWidget(
          const _InfoDialogTestbed(
            title: text,
            backgroundColor: backgroundColor,
          ),
        );

        final dialogWidget = tester.widget<Dialog>(find.byType(Dialog));

        expect(dialogWidget.backgroundColor, equals(backgroundColor));
      },
    );

    testWidgets(
      "applies the given padding to the container widget inside the dialog",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(
            title: text,
            padding: padding,
          ),
        );

        final containerWidget = tester.widget<Container>(
          find.descendant(
            of: find.byType(Dialog),
            matching: find.byType(Container).first,
          ),
        );

        expect(containerWidget.padding, equals(padding));
      },
    );

    testWidgets(
      "applies the given title padding to the title",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(title: text, titlePadding: padding),
        );

        final paddingWidget = tester.widget<Padding>(
          find.byWidgetPredicate(
            (widget) => widget is Padding && widget.child == text,
          ),
        );

        expect(paddingWidget.padding, equals(padding));
      },
    );

    testWidgets(
      "applies the given content padding to the content",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(
            title: text,
            contentPadding: padding,
            content: content,
          ),
        );

        final paddingWidget = tester.widget<Padding>(
          find.byWidgetPredicate(
            (widget) => widget is Padding && widget.child == content,
          ),
        );

        expect(paddingWidget.padding, equals(padding));
      },
    );

    testWidgets(
      "applies the given actions padding to the row of actions",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(
            title: text,
            actions: actions,
            actionsPadding: padding,
          ),
        );

        final paddingWidget = tester.widget<Padding>(
          find.byWidgetPredicate((widget) {
            if (widget is Padding) {
              final childWidget = widget.child;

              return childWidget is Row && childWidget.children == actions;
            }

            return false;
          }),
        );

        expect(paddingWidget.padding, equals(padding));
      },
    );

    testWidgets(
      "applies the given max width value to the container inside the dialog",
      (WidgetTester tester) async {
        const expectedMaxWidth = 200.0;

        await tester.pumpWidget(
          const _InfoDialogTestbed(title: text, maxWidth: expectedMaxWidth),
        );

        final containerWidget = tester.widget<Container>(
          find.descendant(
            of: find.byType(Dialog),
            matching: find.byType(Container).first,
          ),
        );

        expect(containerWidget.constraints.maxWidth, equals(expectedMaxWidth));
      },
    );

    testWidgets(
      "displays the given content",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(title: text, content: content),
        );

        expect(find.byWidget(content), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given actions",
      (WidgetTester tester) async {
        const firstAction = Text('first action text');
        const secondAction = Text('second action text');

        const actions = [firstAction, secondAction];

        await tester.pumpWidget(
          const _InfoDialogTestbed(title: text, actions: actions),
        );

        expect(find.byWidget(firstAction), findsOneWidget);
        expect(find.byWidget(secondAction), findsOneWidget);
      },
    );

    testWidgets(
      "applies the default max width value of 500.0 if nothing is passed",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(title: text),
        );

        final containerWidget = tester.widget<Container>(
          find.descendant(
            of: find.byType(Dialog),
            matching: find.byType(Container).first,
          ),
        );

        expect(containerWidget.constraints.maxWidth, equals(500.0));
      },
    );

    testWidgets(
      "applies the default padding of zero if nothing is passed",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(title: text),
        );

        final containerWidget = tester.widget<Container>(
          find.descendant(
            of: find.byType(Dialog),
            matching: find.byType(Container).first,
          ),
        );

        expect(containerWidget.padding, equals(EdgeInsets.zero));
      },
    );

    testWidgets(
      "applies the default title padding of zero if nothing is passed",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(title: text),
        );

        final widget = tester.widget<Padding>(
          find.byWidgetPredicate(
            (widget) => widget is Padding && widget.child == text,
          ),
        );

        expect(widget.padding, equals(EdgeInsets.zero));
      },
    );

    testWidgets(
      "applies the default content padding of zero if nothing is passed",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(title: text, content: content),
        );

        final widget = tester.widget<InfoDialog>(find.byType(InfoDialog));

        expect(widget.contentPadding, equals(EdgeInsets.zero));
      },
    );
    testWidgets(
      "applies the default actions padding of zero if nothing is passed",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(title: text, actions: actions),
        );

        final widget = tester.widget<Padding>(
          find.byWidgetPredicate((widget) {
            if (widget is Padding) {
              final childWidget = widget.child;

              return childWidget is Row && childWidget.children == actions;
            }

            return false;
          }),
        );

        expect(widget.padding, equals(EdgeInsets.zero));
      },
    );

    testWidgets(
      "applies the default main axis alignement of MainAxisAlignment.start if nothing is passed",
      (WidgetTester tester) async {
        final actions = <Widget>[const Text("Action")];

        await tester.pumpWidget(
          _InfoDialogTestbed(title: text, actions: actions),
        );

        final widget = tester.widget<Row>(
          find.byWidgetPredicate(
            (widget) => widget is Row && widget.children == actions,
          ),
        );

        expect(widget.mainAxisAlignment, equals(MainAxisAlignment.start));
      },
    );

    testWidgets(
      "applies actions alignment to the actions row main axis alignment widget",
      (WidgetTester tester) async {
        const expectedAlignment = MainAxisAlignment.end;

        await tester.pumpWidget(
          const _InfoDialogTestbed(
            title: text,
            actions: actions,
            actionsAlignment: expectedAlignment,
          ),
        );

        final widget = tester.widget<Row>(
          find.byWidgetPredicate(
            (widget) => widget is Row && widget.children == actions,
          ),
        );

        expect(widget.mainAxisAlignment, equals(expectedAlignment));
      },
    );
  });
}

/// A testbed class required to test the [InfoDialog] widget.
class _InfoDialogTestbed extends StatelessWidget {
  /// A background color of this dialog.
  final Color backgroundColor;

  /// An empty space between the main content and dialog's edges.
  final EdgeInsetsGeometry padding;

  /// A max width of this dialog.
  final double maxWidth;

  /// A text title of this dialog.
  final Widget title;

  /// An empty space that surrounds the [title].
  final EdgeInsetsGeometry titlePadding;

  /// A content of this dialog.
  final Widget content;

  /// An empty space that surrounds the [content].
  final EdgeInsetsGeometry contentPadding;

  /// An action bar at the bottom of this dialog.
  final List<Widget> actions;

  /// An empty space that surrounds the [actions].
  final EdgeInsetsGeometry actionsPadding;

  /// A horizontal alignment of the [actions].
  final MainAxisAlignment actionsAlignment;

  /// Creates an instance of this testbed with the given parameters.
  ///
  /// The [actions] defaults to an empty list.
  /// The [padding], the [titlePadding], the [contentPadding]
  /// and the [actionsPadding] default value is [EdgeInsets.zero].
  /// The [actionsAlignment] default value is [MainAxisAlignment.start].
  /// The [maxWidth] default value is 500.0.
  const _InfoDialogTestbed({
    Key key,
    this.title,
    this.actions = const <Widget>[],
    this.content,
    this.backgroundColor,
    this.padding = EdgeInsets.zero,
    this.titlePadding = EdgeInsets.zero,
    this.contentPadding = EdgeInsets.zero,
    this.actionsPadding = EdgeInsets.zero,
    this.actionsAlignment = MainAxisAlignment.start,
    this.maxWidth = 500.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: InfoDialog(
          title: title,
          actions: actions,
          content: content,
          backgroundColor: backgroundColor,
          padding: padding,
          titlePadding: titlePadding,
          contentPadding: contentPadding,
          actionsPadding: actionsPadding,
          maxWidth: maxWidth,
          actionsAlignment: actionsAlignment,
        ),
      ),
    );
  }
}
