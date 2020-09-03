/// A class that stands for different mouse cursors.
class MouseCursor {
  /// A value of this mouse cursor.
  final String cursor;

  /// Creates a new [MouseCursor] instance.
  const MouseCursor._(this.cursor);

  static const MouseCursor basic = MouseCursor._("default");
  static const MouseCursor click = MouseCursor._("pointer");
  static const MouseCursor forbidden = MouseCursor._("not-allowed");
  static const MouseCursor grab = MouseCursor._("grab");
  static const MouseCursor grabbing = MouseCursor._("grabbing");
  static const MouseCursor text = MouseCursor._("text");
}
