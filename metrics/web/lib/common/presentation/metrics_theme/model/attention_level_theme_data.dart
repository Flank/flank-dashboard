/// An abstract class for a theme data that stores a different styles for
/// widgets depending on these widgets feedback for a user.
abstract class AttentionLevelThemeData<T> {
  /// An object that specifies styles for different feedback levels to a user.
  final T attentionLevel;

  /// Creates a new instance of the [AttentionLevelThemeData]
  /// with the given [attentionLevel].
  const AttentionLevelThemeData(this.attentionLevel);
}
