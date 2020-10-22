/// A base class for an image appearance strategy based on value.
abstract class ValueBasedImageStrategy<T> {
  /// Creates a new instance of the [ValueBasedImageStrategy].
  const ValueBasedImageStrategy();

  /// Returns the icon image, based on the [T] value.
  String getIconImage(T value);
}
