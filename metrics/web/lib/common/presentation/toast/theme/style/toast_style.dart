import 'package:flutter/material.dart';

/// A class that stores style data for toasts.
class ToastStyle {
  /// A background [Color] of the toast.
  final Color backgroundColor;

  /// A [TextStyle] for the text in the toast.
  final TextStyle textStyle;

  /// Creates a new instance of the [ToastStyle].
  const ToastStyle({
    this.backgroundColor,
    this.textStyle,
  });
}
