// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';

/// A class that represents the links checker command-line arguments.
class LinksCheckerArguments {
  /// A target repository to analyze.
  final String repository;

  /// A [List] of paths to files to analyze.
  final List<String> paths;

  /// A [List] of paths to exclude from the analyze.
  final List<String> ignorePaths;

  /// Creates a new instance of the [LinksCheckerArguments].
  ///
  /// Throws an [ArgumentError] if the given [paths] or
  /// [repository] is `null`.
  LinksCheckerArguments({
    @required this.repository,
    @required this.paths,
    this.ignorePaths,
  }) {
    ArgumentError.checkNotNull(repository, 'repository');
    ArgumentError.checkNotNull(paths, 'paths');
  }
}
