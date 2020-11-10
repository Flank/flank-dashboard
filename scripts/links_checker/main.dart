import 'dart:io';

void main(List<String> arguments) {
  final changedFiles = _getChangedFiles(arguments);
  final errors = _analyzeFiles(changedFiles);

  if (errors.isNotEmpty) {
    print('Found ${errors.length} links not pointing to master:');
    errors.forEach(print);
    
    exit(1);
  }

  exit(0);
}

/// Returns a list of changed [File]s by the the given [paths].
List<File> _getChangedFiles(List<String> paths) {
  final result = <File>[];

  for (final path in paths) {
    final file = File(path);

    if (file.existsSync()) result.add(file);
  }

  return result;
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
/// of errors occured in the given [file].
///
/// Returns an empty list if there are no errors.
List<String> _analyzeFile(File file) {
  final errors = <String>[];
  int lineIndex = 1;

  try {
    final fileContent = file.readAsStringSync();
    final lines = fileContent.split('\n');

    for (final line in lines) {
      final urls = _parseMonorepoUrls(line);

      for (final url in urls) {
        if (!_pointsToMaster(url)) {
          final errorDescription = 'In ${file.path}, line $lineIndex, $url';

          errors.add(errorDescription);
        }
      }

      ++lineIndex;
    }
  } finally {
    return errors;
  }
}

/// Returns a list of Monorepo URLs from the given [string].
List<String> _parseMonorepoUrls(String string) {
  final urls = _parseUrls(string);

  return urls.where((url) => _isMonorepoUrl(url)).toList();
}

/// Returns a list of URLs from the given [string] matching the URL [RegExp].
List<String> _parseUrls(String string) {
  final urlRegExp = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)');

  return urlRegExp.allMatches(string).map((match) => match.group(0)).toList();
}

/// Returns `true` if the given [url] contains any of the Monorepo URL prefixes.
bool _isMonorepoUrl(String url) {
  final monorepoPrefixes = _getMonorepoPrefixes();

  return monorepoPrefixes.any((prefix) => url.contains(prefix));
}

/// Returns `true` if the given [url] points to `master` branch or is a raw
/// Monorepo URL prefix.
bool _pointsToMaster(String url) {
  final rawPrefixes = _getMonorepoPrefixes();
  final masterPrefixes = _getMonorepoPrefixes(withPostfix: '/master');

  final isRawPrefix = rawPrefixes.any((prefix) => prefix == url);
  final pointsToMaster = masterPrefixes.any((prefix) => url.contains(prefix));

  return pointsToMaster || isRawPrefix;
}

/// Returns a list of Monorepo URL prefixes appended with
/// the given [withPostfix].
///
/// If the given [withPostfix] is `null`, an empty string is used.
List<String> _getMonorepoPrefixes({String withPostfix}) {
  const prefixes = [
    'https://raw.githubusercontent.com/platform-platform/monorepo',
    'https://github.com/platform-platform/monorepo/blob',
    'https://github.com/platform-platform/monorepo/raw',
    'https://github.com/platform-platform/monorepo/tree',
  ];

  return prefixes.map((prefix) => '$prefix${withPostfix ?? ''}').toList();
}
