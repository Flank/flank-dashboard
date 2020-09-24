import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/keyboard_shortcuts.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("KeyboardShortcuts", () {
    const keyboardKey = LogicalKeyboardKey.keyF;
    final keysToPress = LogicalKeySet(keyboardKey);

    testWidgets(
      "throws an AssertionError if the given child is null",
      (tester) async {
        await tester.pumpWidget(const _KeyboardShortcutsTestbed(child: null));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given on keys pressed is null",
      (tester) async {
        await tester.pumpWidget(
          const _KeyboardShortcutsTestbed(onKeysPressed: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets("displays the given child", (tester) async {
      const child = Text('child');

      await tester.pumpWidget(
        const _KeyboardShortcutsTestbed(child: child),
      );

      expect(find.byWidget(child), findsOneWidget);
    });

    testWidgets(
      "applies the given keyboard keys to the shortcut widget",
      (tester) async {
        await tester.pumpWidget(
          _KeyboardShortcutsTestbed(
            keysToPress: keysToPress,
            onKeysPressed: (_) => null,
          ),
        );

        final shortcutWidget = tester.widget<Shortcuts>(
          find.descendant(
            of: find.byType(KeyboardShortcuts),
            matching: find.byType(Shortcuts),
          ),
        );

        expect(shortcutWidget.shortcuts.containsKey(keysToPress), isTrue);
      },
    );
  });
}

/// A testbed class needed to test the [KeyboardShortcuts] widget.
class _KeyboardShortcutsTestbed extends StatelessWidget {
  /// A default child widget used in tests.
  static const Widget _defaultChild = Text('default text');

  /// A widget to display.
  final Widget child;

  /// A combination of the keyboard keys
  /// to trigger the given [onKeysPressed] callback.
  final LogicalKeySet keysToPress;

  /// A callback that triggers after the [keysToPress] is pressed.
  final OnInvokeCallback onKeysPressed;

  /// Creates a new instance of the keyboard shortcuts testbed.
  ///
  /// The [child] defaults to [_defaultChild].
  const _KeyboardShortcutsTestbed({
    Key key,
    this.child = _defaultChild,
    this.keysToPress,
    this.onKeysPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: KeyboardShortcuts(
          onKeysPressed: onKeysPressed,
          keysToPress: keysToPress,
          child: child,
        ),
      ),
    );
  }
}
