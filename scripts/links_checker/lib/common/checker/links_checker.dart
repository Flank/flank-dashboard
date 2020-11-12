import 'dart:io';

import 'package:links_checker/common/exception/links_checker_exception.dart';

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

  /// A URL [RegExp] to parse URLs.
  final urlRegExp = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)');

  /// Returns a list of [File]s by the the given [paths].
  List<File> parse(String paths) {
    final files = <File>[];

    for (final path in paths.split(' ')) {
      final file = File(path);

      if (file.existsSync()) files.add(file);
    }

    return files;
  }

  /// Runs checks for all files.
  void check(List<File> files) {
    final analysisResult = _analyzeFiles(files);

    if (analysisResult.isNotEmpty) {
      throw LinksCheckerException(analysisResult);
    }
  }

  /// Analyzes the given [files] and returns a list containing descriptions
  /// of errors occurred in the given [files].
  ///
  /// Returns an empty list if there are no errors.
  List<String> _analyzeFiles(List<File> files) {
    final errors = <String>[];

    for (final file in files) {
      final fileErrors = _analyzeFile(file);
      errors.addAll(fileErrors);
    }

    return errors;
  }

  /// Analyzes the given [file] and returns a list containing descriptions
  /// of errors occurred in the given [file].
  ///
  /// Returns an empty list if there are no errors or the file's content can't be
  /// readed.
  List<String> _analyzeFile(File file) {
    final errors = <String>[];
    final fileContent = _getFileContent(file);

    if (fileContent == null) return errors;

    int lineIndex = 1;
    final lines = fileContent.split('\n');

    for (final line in lines) {
      final urls = _parseMonorepoUrls(line);

      for (final url in urls) {
        if (!_isValidUrl(url)) {
          final errorDescription = 'In ${file.path}, line $lineIndex, $url';

          errors.add(errorDescription);
        }
      }

      ++lineIndex;
    }

    return errors;
  }

  /// Returns the [file]'s content as a [String].
  ///
  /// Returns `null`, if the given [file] can't be read.
  String _getFileContent(File file) {
    try {
      return file.readAsStringSync();
    } catch (e) {
      return null;
    }
  }

  /// Returns a list of Monorepo URLs from the given [string].
  List<String> _parseMonorepoUrls(String string) {
    final urls = _parseUrls(string);

    return urls.where((url) => _isMonorepoUrl(url)).toList();
  }

  /// Returns a list of URLs from the given [string] matching the URL [RegExp].
  List<String> _parseUrls(String string) {
    return urlRegExp.allMatches(string).map((match) => match.group(0)).toList();
  }

  /// Returns `true` if the given [url] contains any of the Monorepo URL prefixes.
  bool _isMonorepoUrl(String url) {
    return _prefixes.any((prefix) => url.contains(prefix));
  }

  /// Returns `true` if the given [url] points to `master` branch or is a raw
  /// Monorepo URL prefix.
  bool _isValidUrl(String url) {
    final masterPrefixes = _prefixes.map((prefix) => '$prefix/master').toList();

    final pointsToMaster = masterPrefixes.any((prefix) => url.contains(prefix));
    final isRawPrefix = _prefixes.any((prefix) => url.endsWith(prefix));

    return pointsToMaster || isRawPrefix;
  }
}
