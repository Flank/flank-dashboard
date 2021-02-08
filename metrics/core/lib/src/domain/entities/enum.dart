// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

/// An abstract class representing the enum with the custom value.
abstract class Enum<T> {
  /// A value of this enum.
  final T value;

  /// Creates an instance of this [Enum] with the given [value].
  const Enum(this.value);
}
