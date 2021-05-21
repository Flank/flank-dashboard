// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:args/args.dart';
import 'package:links_checker/cli/arguments/models/links_checker_arguments.dart';

/// A class that provides methods for registering
/// and parsing the [LinksCheckerArguments].
class LinksCheckerArgumentsParser {
  /// A name of the paths argument.
  static const String paths = 'paths';

  /// A name of the ignore paths argument.
  static const String ignorePaths = 'ignore-paths';

  /// Creates a new instance of the [LinksCheckerArgumentsParser].
  const LinksCheckerArgumentsParser();

  /// Configures the given [argParser] to accept the required arguments.
  void configureArguments(ArgParser argParser) {
    argParser.addOption(
      paths,
      help: 'A string representing the space-separated '
          'paths to files to analyze.',
      valueHelp: "'file1 path/to/file2 another/path/to/file3'",
      abbr: 'p',
      defaultsTo: '',
    );

    argParser.addOption(
      ignorePaths,
      help: 'A string representing the space-separated '
          'paths which should be excluded from analyze.',
      valueHelp: "'.folder/ path/to/folder/ file.ext'",
    );
  }

  /// Parses the [argResults] to the [LinksCheckerArguments] object.
  LinksCheckerArguments parseArgResults(ArgResults argResults) {
    final pathsList = _argumentToList(argResults, paths);
    final ignoreList = _argumentToList(argResults, ignorePaths);

    return LinksCheckerArguments(paths: pathsList, ignorePaths: ignoreList);
  }

  /// Retrieves argument [List] for the given [option] from the given [argResults].
  List<String> _argumentToList(ArgResults argResults, String option) {
    final argument = argResults[option] as String;

    if (argument == null) return null;

    return argument.split(' ').where((path) => path.isNotEmpty).toList();
  }
}
