// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:links_checker/checker/error/links_checker_error.dart';

/// A class that checks that all Monorepo URLs point to the master branch
/// in the given files.
class LinksChecker {
  /// A [List] of URL prefixes that indicate that the URL points to the Monorepo
  /// repository.
  final List<String> _prefixes = [
    'raw.githubusercontent.com/platform-platform/monorepo',
    'github.com/platform-platform/monorepo/blob',
    'github.com/platform-platform/monorepo/raw',
    'github.com/platform-platform/monorepo/tree',
  ];

  /// A [RegExp] to parse URLs.
  final urlRegExp = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)');

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
      final invalidUrls = _parseMonorepoUrls(lines[i]).skipWhile(_isValidUrl);

      final descriptions =
          invalidUrls.map((url) => 'In ${file.path}, line ${i + 1}, $url');

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

  /// Returns a list of Monorepo URLs from the given [string].
  List<String> _parseMonorepoUrls(String string) {
    final urls =
        urlRegExp.allMatches(string).map((match) => match.group(0)).toList();

    return urls
        .where((url) => _prefixes.any((prefix) => url.contains(prefix)))
        .toList();
  }

  /// Returns `true` if the given [url] points to `master` branch or is a raw
  /// Monorepo URL prefix.
  bool _isValidUrl(String url) {
    final masterPrefixes =
        _prefixes.map((prefix) => '$prefix/master/').toList();

    final pointsToMaster = masterPrefixes.any((prefix) => url.contains(prefix));
    final isMonorepoLink = _prefixes.any((prefix) => url.endsWith(prefix));

    return pointsToMaster || isMonorepoLink;
  }
}
