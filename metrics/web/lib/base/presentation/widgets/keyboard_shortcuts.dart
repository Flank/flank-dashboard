// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A widget that triggers the given callback
/// in response to a press of the given keyboard keys.
class KeyboardShortcuts extends StatelessWidget {
  /// A combination of the keyboard keys
  /// to trigger the given [onKeysPressed] callback.
  final LogicalKeySet keysToPress;

  /// A callback that triggers after the [keysToPress] is pressed.
  final VoidCallback onKeysPressed;

  /// A widget below this keyboard shortcuts in the tree.
  final Widget child;

  /// Creates a new instance of the [KeyboardShortcuts].
  ///
  /// The [child], [onKeysPressed] and [keysToPress] must not be `null`.
  const KeyboardShortcuts({
    Key key,
    @required this.child,
    @required this.onKeysPressed,
    @required this.keysToPress,
  })  : assert(child != null),
        assert(onKeysPressed != null),
        assert(keysToPress != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        keysToPress: const _KeyboardShortcutActivateIntent(),
      },
      child: Actions(
        actions: {
          _KeyboardShortcutActivateIntent: CallbackAction(
            onInvoke: (_) => onKeysPressed(),
          ),
        },
        child: child,
      ),
    );
  }
}

/// An intent that activates the keyboard shortcuts.
class _KeyboardShortcutActivateIntent extends Intent {
  /// Creates a new instance of the [_KeyboardShortcutActivateIntent].
  const _KeyboardShortcutActivateIntent();
}
