/// A class that represents the links checker arguments.
class LinksCheckerArguments {
  /// A [List] of paths of files to analyze.
  final List<String> paths;

  /// Creates a new instance of the [LinksCheckerArguments].
  ///
  /// Throws an [ArgumentError] if the given [paths] is `null`.
  LinksCheckerArguments({this.paths}) {
    ArgumentError.checkNotNull(paths, 'paths');
  }
}
