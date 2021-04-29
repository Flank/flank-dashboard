// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/info_dialog.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';

void main() {
  group("InfoDialog", () {
    const content = Text('content text');
    const padding = EdgeInsets.all(10.0);
    const actions = [Text('Action')];
    const title = Text('title');

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
      "throws an AssertionError if the given actions are null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(
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
            title: title,
          ),
        );

        expect(find.byWidget(title), findsOneWidget);
      },
    );

    testWidgets(
      "applies the given background color to the dialog",
      (WidgetTester tester) async {
        const backgroundColor = Colors.red;

        await tester.pumpWidget(
          const _InfoDialogTestbed(
            backgroundColor: backgroundColor,
          ),
        );

        final dialogWidget = tester.widget<Dialog>(find.byType(Dialog));

        expect(dialogWidget.backgroundColor, equals(backgroundColor));
      },
    );

    testWidgets(
      "applies the given padding to the dialog",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(
            padding: padding,
          ),
        );

        final paddingWidget = tester.widget<Padding>(
          find.byWidgetPredicate(
            (widget) => widget is Padding && widget.child is Column,
          ),
        );

        expect(paddingWidget.padding, equals(padding));
      },
    );

    testWidgets(
      "applies the given padding to the close icon",
      (WidgetTester tester) async {
        const closeIcon = Icon(Icons.close);

        await tester.pumpWidget(
          const _InfoDialogTestbed(
            closeIcon: closeIcon,
            closeButtonPadding: padding,
          ),
        );

        final stackFinder = find.ancestor(
          of: find.byWidget(closeIcon),
          matching: find.byType(Stack),
        );

        final paddingWidget = tester.widget<Padding>(
          find.ancestor(
            of: find.byWidget(closeIcon),
            matching: find.descendant(
              of: stackFinder,
              matching: find.byType(Padding),
            ),
          ),
        );

        expect(paddingWidget.padding, equals(padding));
      },
    );

    testWidgets(
      "applies the given title padding to the title",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(title: title, titlePadding: padding),
        );

        final paddingWidget = tester.widget<Padding>(
          find.byWidgetPredicate(
            (widget) => widget is Padding && widget.child == title,
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
      "applies the given box constraints to the dialog",
      (WidgetTester tester) async {
        const constraints = BoxConstraints(minWidth: 200.0);

        await tester.pumpWidget(
          const _InfoDialogTestbed(constraints: constraints),
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(Dialog),
            matching: find.byType(Container).first,
          ),
        );

        expect(container.constraints, equals(constraints));
      },
    );

    testWidgets(
      "displays the given content",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(content: content),
        );

        expect(find.byWidget(content), findsOneWidget);
      },
    );

    testWidgets(
      "displays the given actions",
      (WidgetTester tester) async {
        const firstAction = Text('first action');
        const secondAction = Text('second action');

        const actions = [firstAction, secondAction];

        await tester.pumpWidget(
          const _InfoDialogTestbed(actions: actions),
        );

        expect(find.byWidget(firstAction), findsOneWidget);
        expect(find.byWidget(secondAction), findsOneWidget);
      },
    );

    testWidgets(
      "displays the default close icon if the given is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(),
        );

        final iconFinder = find.byIcon(Icons.close);

        expect(iconFinder, findsOneWidget);
      },
    );

    testWidgets("displays the given close icon", (WidgetTester tester) async {
      const closeIcon = Icon(Icons.cancel);

      await tester.pumpWidget(
        const _InfoDialogTestbed(
          closeIcon: closeIcon,
        ),
      );

      expect(
        find.byWidget(closeIcon),
        findsOneWidget,
      );
    });

    testWidgets(
      "applies actions alignment to the actions row main axis alignment widget",
      (WidgetTester tester) async {
        const expectedAlignment = MainAxisAlignment.end;

        await tester.pumpWidget(
          const _InfoDialogTestbed(
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

    testWidgets(
      "applies a tappable area to the close icon button",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const _InfoDialogTestbed(
            contentPadding: padding,
            content: content,
          ),
        );

        final finder = find.ancestor(
          of: find.byIcon(Icons.close),
          matching: find.byType(TappableArea),
        );

        expect(finder, findsOneWidget);
      },
    );

    testWidgets(
      "applies the given shape to the dialog's border",
      (WidgetTester tester) async {
        const shape = RoundedRectangleBorder(
          side: BorderSide(color: Colors.green),
        );

        await tester.pumpWidget(
          const _InfoDialogTestbed(shape: shape),
        );

        final dialog = tester.widget<Dialog>(find.byType(Dialog));

        expect(dialog.shape, equals(shape));
      },
    );
  });
}

/// A testbed class required to test the [InfoDialog] widget.
class _InfoDialogTestbed extends StatelessWidget {
  /// A shape of this dialog's border.
  final ShapeBorder shape;

  /// A background color of this dialog.
  final Color backgroundColor;

  /// An empty space between the main content and dialog's edges.
  final EdgeInsetsGeometry padding;

  /// A widget that is displayed as a close button for this dialog.
  final Widget closeIcon;

  /// An empty space that surrounds the close button.
  final EdgeInsetsGeometry closeButtonPadding;

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

  /// A [BoxConstraints] to apply to the [InfoDialog].
  final BoxConstraints constraints;

  /// Creates an instance of this testbed with the given parameters.
  ///
  /// The [padding], the [titlePadding], the [contentPadding],
  /// the [actionsPadding], and the [closeButtonPadding]
  /// default value is [EdgeInsets.zero].
  ///
  /// The [actionsAlignment] default value is [MainAxisAlignment.start].
  /// If the [closeIcon] is null, the [Icon] with [Icons.close] is used.
  ///
  /// The [title] and the [actions] must not be null.
  const _InfoDialogTestbed({
    Key key,
    this.title = const Text('text'),
    this.actions = const <Widget>[],
    this.shape,
    this.content,
    this.closeIcon,
    this.backgroundColor,
    this.padding = EdgeInsets.zero,
    this.titlePadding = EdgeInsets.zero,
    this.contentPadding = EdgeInsets.zero,
    this.actionsPadding = EdgeInsets.zero,
    this.closeButtonPadding = EdgeInsets.zero,
    this.actionsAlignment = MainAxisAlignment.start,
    this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: InfoDialog(
          shape: shape,
          title: title,
          actions: actions,
          content: content,
          backgroundColor: backgroundColor,
          padding: padding,
          closeIcon: closeIcon,
          closeIconPadding: closeButtonPadding,
          titlePadding: titlePadding,
          contentPadding: contentPadding,
          actionsPadding: actionsPadding,
          actionsAlignment: actionsAlignment,
          constraints: constraints,
        ),
      ),
    );
  }
}
