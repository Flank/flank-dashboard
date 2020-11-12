import 'package:args/args.dart';
import 'package:links_checker/common/arguments/models/links_checker_arguments.dart';
import 'package:links_checker/common/arguments/parser/links_checker_arguments_parser.dart';
import 'package:test/test.dart';

void main() {
  group("LinksCheckerArgumentsParser", () {
    test(
      ".configureArguments() configures the given arg parser to accept the paths option",
      () {
        final parser = ArgParser();
        final argumentsParser = _ArgumentsParserFake();

        argumentsParser.configureArguments(parser);

        final options = parser.options;

        expect(options, contains(LinksCheckerArgumentsParser.paths));
      },
    );
  });
}

/// An [ArgumentsParser] fake class needed to test the non-abstract methods.
class _ArgumentsParserFake extends LinksCheckerArgumentsParser {
  @override
  LinksCheckerArguments parseArgResults(ArgResults argResults) => null;
}
