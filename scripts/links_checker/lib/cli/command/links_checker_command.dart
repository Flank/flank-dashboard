// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:args/command_runner.dart';
import 'package:links_checker/checker/factory/links_checker_factory.dart';
import 'package:links_checker/checker/links_checker.dart';
import 'package:links_checker/cli/arguments/parser/links_checker_arguments_parser.dart';
import 'package:links_checker/utils/file_helper_util.dart';

/// A [LinksCheckerCommand] used to check links validity in files.
class LinksCheckerCommand extends Command<void> {
  /// An [LinksCheckerArgumentsParser] used to parse the arguments for
  /// this command.
  final LinksCheckerArgumentsParser argumentsParser;

  /// A class that provides methods for working with files.
  final FileHelperUtil fileHelperUtil;

  /// A [LinksCheckerFactory] that creates an instance of [LinksChecker]
  /// to validates URLs for a list of files.
  final LinksCheckerFactory linksCheckerFactory;

  @override
  String get description => 'Check links validity in the given files.';

  @override
  String get name => 'validate';

  /// Creates a new instance of the [LinksCheckerCommand]
  /// with the given [argumentsParser], [fileHelperUtil] and
  /// [linksCheckerFactory].
  ///
  /// If the [argumentsParser] is `null`,
  /// the [LinksCheckerArgumentsParser] is used.
  /// If the [fileHelperUtil] is `null`, the [FileHelperUtil] is used.
  /// If the [linksCheckerFactory] is `null`, the [LinksCheckerFactory] is used.
  LinksCheckerCommand({
    LinksCheckerArgumentsParser argumentsParser,
    FileHelperUtil fileHelperUtil,
    LinksCheckerFactory linksCheckerFactory,
  })  : argumentsParser =
            argumentsParser ?? const LinksCheckerArgumentsParser(),
        fileHelperUtil = fileHelperUtil ?? const FileHelperUtil(),
        linksCheckerFactory =
            linksCheckerFactory ?? const LinksCheckerFactory() {
    this.argumentsParser.configureArguments(argParser);
  }

  @override
  void run() {
    final arguments = argumentsParser.parseArgResults(argResults);

    final ignorePaths = arguments.ignorePaths;
    final paths = _excludeIgnorePaths(arguments.paths, ignorePaths);
    final files = fileHelperUtil.getFiles(paths);

    final linksChecker = linksCheckerFactory.create(arguments.repository);
    linksChecker.checkFiles(files);
  }

  /// Excludes the given [ignorePaths] from the given [paths].
  List<String> _excludeIgnorePaths(
    List<String> paths,
    List<String> ignorePaths,
  ) {
    if (ignorePaths == null || ignorePaths.isEmpty) return paths;

    return paths.where((path) {
      return !ignorePaths.any((ignorePath) => path.startsWith(ignorePath));
    }).toList();
  }
}
