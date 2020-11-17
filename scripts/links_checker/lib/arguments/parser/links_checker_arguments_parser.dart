import 'package:args/args.dart';
import 'package:links_checker/arguments/models/links_checker_arguments.dart';

/// A class that provides methods for registering
/// and parsing the [LinksCheckerArguments].
class LinksCheckerArgumentsParser {
  /// Creates a new instance of the [LinksCheckerArgumentsParser].
  const LinksCheckerArgumentsParser();

  /// A name of the paths argument.
  static const String paths = 'paths';

  /// Configures the given [argParser] to accept the required arguments.
  void configureArguments(ArgParser argParser) {
    argParser.addOption(
      paths,
      help:
          'A string representing the space-separated paths of files to analyze.',
      valueHelp: "'file1 file2 file3'",
      abbr: 'p',
    );
  }

  /// Parses the [argResults] to the [LinksCheckerArguments] object.
  LinksCheckerArguments parseArgResults(ArgResults argResults) {
    final pathsArg = argResults[paths] as String;
    final pathsList = pathsArg.split(' ');

    return LinksCheckerArguments(paths: pathsList);
  }
}
