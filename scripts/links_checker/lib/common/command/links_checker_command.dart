import 'package:args/command_runner.dart';
import 'package:links_checker/common/arguments/parser/links_checker_arguments_parser.dart';
import 'package:links_checker/common/checker/links_checker.dart';

/// A [LinksCheckerCommand] used to check links validity in files.
class LinksCheckerCommand extends Command<void> {
  /// An [ArgumentsParser] used to parse the arguments for this command.
  final LinksCheckerArgumentsParser argumentsParser;

  /// Creates a new instance of the [LinksCheckerCommand]
  /// with the given [argumentsParser].
  ///
  /// If the [argumentsParser] is `null`,
  /// the [LinksCheckerArgumentsParser] is used.
  LinksCheckerCommand({
    LinksCheckerArgumentsParser argumentsParser,
  }) : argumentsParser = argumentsParser ?? LinksCheckerArgumentsParser() {
    this.argumentsParser.configureArguments(argParser);
  }

  @override
  String get description => 'Check links validity in files';

  @override
  String get name => 'links_checker';

  @override
  void run() {
    final arguments = argumentsParser.parseArgResults(argResults);

    final checker = LinksChecker(arguments.paths);

    checker.check();
  }
}
