/// An abstract class representing the enum with the custom value.
abstract class Enum<T> {
  /// A value of this enum.
  final T value;

  /// Creates an instance of this [Enum] with the given [value].
  const Enum(this.value);
}
