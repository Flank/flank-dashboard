/// A base class for a strategy of applying the image asset based on a value.
abstract class ValueBasedImageAssetStrategy<T> {
  /// Creates a new instance of the [ValueBasedImageAssetStrategy].
  const ValueBasedImageAssetStrategy();

  /// Returns an image asset depending on the given [value].
  String getImageAsset(T value);
}
