// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:links_checker/checker/links_checker.dart';

/// A factory class that provides a method for creating a new
/// instance of the [LinksChecker].
class LinksCheckerFactory {
  /// Creates a new instance of the [LinksCheckerFactory].
  const LinksCheckerFactory();

  /// Creates a new instance of the [LinksChecker] with the repository prefixes
  /// based on the given [repository].
  ///
  /// Throws an [ArgumentError] if the given [repository] is null.
  LinksChecker create(String repository) {
    ArgumentError.checkNotNull(repository, 'repository');

    final repositoryPrefixes = [
      'raw.githubusercontent.com/$repository',
      'github.com/$repository/blob',
      'github.com/$repository/raw',
      'github.com/$repository/tree',
    ];

    return LinksChecker(repositoryPrefixes);
  }
}
