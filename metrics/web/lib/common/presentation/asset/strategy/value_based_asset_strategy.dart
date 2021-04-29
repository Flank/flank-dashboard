// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// A base class for a strategy of applying the assets based on a value.
abstract class ValueBasedAssetStrategy<T> {
  /// Creates a new instance of the [ValueBasedAssetStrategy].
  const ValueBasedAssetStrategy();

  /// Returns an asset depending on the given [value].
  String getAsset(T value);
}
