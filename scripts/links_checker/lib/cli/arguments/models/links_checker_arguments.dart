// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

/// A class that represents the links checker arguments.
class LinksCheckerArguments {
  /// A [List] of paths to files to analyze.
  final List<String> paths;

  /// A [List] of paths to exclude from the analyze.
  final List<String> ignorePaths;

  /// Creates a new instance of the [LinksCheckerArguments].
  ///
  /// Throws an [ArgumentError] if the given [paths] is `null`.
  LinksCheckerArguments({this.paths, this.ignorePaths}) {
    ArgumentError.checkNotNull(paths, 'paths');
  }
}
