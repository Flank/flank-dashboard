import 'package:flutter/material.dart';

/// A widget that triggers the given callback
/// in response to a press of the given keyboard keys.
class KeyboardShortcuts extends StatelessWidget {
  /// A combination of the keyboard keys
  /// to trigger the given [onKeysPressed] callback.
  final LogicalKeySet keysToPress;

  /// A callback that triggers after the [keysToPress] is pressed.
  final OnInvokeCallback onKeysPressed;

  /// A widget below this keyboard shortcuts in the tree.
  final Widget child;

  /// Creates a new instance of the [KeyboardShortcuts].
  ///
  /// The [child] and [onKeysPressed] must not be `null`.
  const KeyboardShortcuts({
    Key key,
    @required this.child,
    @required this.onKeysPressed,
    this.keysToPress,
  })  : assert(child != null),
        assert(onKeysPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        keysToPress: const ActivateIntent(),
      },
      child: Actions(
        actions: {
          ActivateIntent: CallbackAction(
            onInvoke: onKeysPressed,
          ),
        },
        child: child,
      ),
    );
  }
}
