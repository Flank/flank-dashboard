// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:links_checker/checker/error/links_checker_error.dart';

/// A class that checks that all repository URLs identified by the given
/// [repositoryPrefixes] point to the master branch in the given files.
class LinksChecker {
  /// A [List] of repository URL prefixes the URLs of that repository
  /// start with.
  final List<String> repositoryPrefixes;

  /// A [RegExp] to parse URLs.
  final urlRegExp = RegExp(
    r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)',
  );

  /// Creates a new instance of the [LinksChecker] with the given
  /// [repositoryPrefixes].
  LinksChecker(this.repositoryPrefixes);

  /// Checks all the given [files] to contain links that point to master.
  void checkFiles(List<File> files) {
    final errors = <String>[];

    for (final file in files) {
      final fileErrors = _analyzeFile(file);
      errors.addAll(fileErrors);
    }

    if (errors.isNotEmpty) {
      throw LinksCheckerError(errors);
    }
  }

  /// Analyzes the given [file] and returns a list containing descriptions
  /// of errors in the given [file].
  ///
  /// Returns an empty list if there are no errors or reading the [file]
  /// content is failed.
  List<String> _analyzeFile(File file) {
    final errors = <String>[];
    final fileContent = _getFileContent(file);

    if (fileContent == null) return errors;

    final lines = fileContent.split('\n');

    for (int i = 0; i < lines.length; ++i) {
      final invalidUrls = _getRepositoryUrls(lines[i]).skipWhile(_isValidUrl);

      final descriptions = invalidUrls.map(
        (url) => 'In ${file.path}, line ${i + 1}, $url',
      );

      errors.addAll(descriptions);
    }

    return errors;
  }

  /// Returns the content of the given [file].
  ///
  /// Returns `null`, if reading the given [file] fails.
  String _getFileContent(File file) {
    try {
      return file.readAsStringSync();
    } catch (e) {
      return null;
    }
  }

  /// Returns a list of repository URLs from the given [string] having the
  /// [repositoryPrefixes].
  List<String> _getRepositoryUrls(String string) {
    final urls = urlRegExp.allMatches(string).map((match) => match.group(0));

    return urls
        .where(
          (url) => repositoryPrefixes.any(
            (prefix) => url.contains(prefix),
          ),
        )
        .toList();
  }

  /// Detects whether the given [url] points to `master` branch or is a root
  /// link.
  bool _isValidUrl(String url) {
    final masterPrefixes =
        repositoryPrefixes.map((prefix) => '$prefix/master/');

    final pointsToMaster = masterPrefixes.any((prefix) => url.contains(prefix));
    final isRootLink = repositoryPrefixes.any(
      (prefix) => url.endsWith(prefix),
    );

    return pointsToMaster || isRootLink;
  }
}
