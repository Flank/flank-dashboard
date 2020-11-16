import 'package:args/command_runner.dart';
import 'package:links_checker/common/arguments/parser/links_checker_arguments_parser.dart';
import 'package:links_checker/common/checker/links_checker.dart';
import 'package:links_checker/common/utils/file_helper.dart';

/// A [LinksCheckerCommand] used to check links validity in files.
class LinksCheckerCommand extends Command<void> {
  /// An [ArgumentsParser] used to parse the arguments for this command.
  final LinksCheckerArgumentsParser argumentsParser;

  /// A class that provides methods for working with files.
  final FileHelper fileHelper;

  /// A [LinksChecker] that validates URLs for a list of files.
  LinksChecker get linksChecker => LinksChecker();

  /// Creates a new instance of the [LinksCheckerCommand]
  /// with the given [argumentsParser].
  ///
  /// If the [argumentsParser] is `null`,
  /// the [LinksCheckerArgumentsParser] is used.
  LinksCheckerCommand({
    LinksCheckerArgumentsParser argumentsParser,
    FileHelper fileHelper,
  })  : argumentsParser = argumentsParser ?? LinksCheckerArgumentsParser(),
        fileHelper = fileHelper ?? const FileHelper() {
    this.argumentsParser.configureArguments(argParser);
  }

  @override
  String get description => 'Check links validity in the given files.';

  @override
  String get name => 'validate';

  @override
  void run() {
    final arguments = argumentsParser.parseArgResults(argResults);

    final files = fileHelper.getFiles(arguments.paths);

    linksChecker.checkFiles(files);
  }
}
