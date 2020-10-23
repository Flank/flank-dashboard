/// A base class for an image asset strategy based on value.
abstract class ValueBasedImageAssetStrategy<T> {
  /// Creates a new instance of the [ValueBasedImageAssetStrategy].
  const ValueBasedImageAssetStrategy();

  /// Returns an image asset depending on the given [value].
  String getImageAsset(T value);
}
