import 'package:args/args.dart';
import 'package:links_checker/arguments/parser/links_checker_arguments_parser.dart';
import 'package:test/test.dart';

// ignore_for_file:

void main() {
  group("LinksCheckerArgumentsParser", () {
    test(
      ".configureArguments() configures the given arg parser to accept the paths option",
      () {
        final parser = ArgParser();
        const argumentsParser = LinksCheckerArgumentsParser();

        argumentsParser.configureArguments(parser);

        final options = parser.options;

        expect(options, contains(LinksCheckerArgumentsParser.paths));
      },
    );

    test(
      ".parseArgResults() parses the given paths option value to a links checker arguments instance with paths",
      () {
        const paths = 'file1 path/to/file2';
        const options = ['--paths', paths];

        final expected = ['file1', 'path/to/file2'];

        final parser = ArgParser();
        const argumentsParser = LinksCheckerArgumentsParser();

        argumentsParser.configureArguments(parser);

        final argResults = parser.parse(options);
        final arguments = argumentsParser.parseArgResults(argResults);

        expect(arguments.paths, equals(expected));
      },
    );
  });
}
